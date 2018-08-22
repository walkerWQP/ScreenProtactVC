//
//  ViewController.m
//  ScreenProtactVC
//
//  Created by pgy on 16/11/12.
//  Copyright © 2016年 pgy. All rights reserved.
//

#import "ViewController.h"

#define KScreenW [UIScreen mainScreen].bounds.size.width
#define KScreenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

//圆点
@property(nonatomic,strong)UILabel *labelCrile1;
@property(nonatomic,strong)UILabel *labelCrile2;
@property(nonatomic,strong)UILabel *labelCrile3;
@property(nonatomic,strong)UILabel *labelCrile4;

//密码输入框
@property(nonatomic,strong)UITextField *tf;

//覆盖输入框的视图
@property(nonatomic,strong)UIView *view1;

//模拟键盘的集合视图
@property(nonatomic,strong)UICollectionView *collectionView;

//键盘文字
@property(nonatomic,strong)NSArray *array;

//点击的模拟键盘获取到的字符串
@property(nonatomic,copy)NSString *numberCount;

//密码输入错的提示框
@property(nonatomic,strong)UILabel *label1;

//密码输入错误次数
@property(nonatomic,assign)NSInteger errorCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:72/255.0 green:179/255.0 blue:249/255.0 alpha:1];
    
    //模拟用户设置的安全密码 ，保存在本地
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1234" forKey:@"passWord"];
    
    //设置可以输错的次数
    _errorCount = 4;
    
    //加载控件
    [self createInPutPassWordSubViews];
}

- (void)createInPutPassWordSubViews{
    //提示
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 80, KScreenW-60, 30)];
    label.text = @"请输入安全锁密码";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    //输入框
    _tf = [[UITextField alloc]initWithFrame:CGRectMake(KScreenW/2-50, 130, 100, 20)];
    _tf.backgroundColor = [UIColor clearColor];
    _tf.tintColor = [UIColor clearColor];
    [self.view addSubview:_tf];
    
    //放置圆点的视图  覆盖输入框
    _view1 = [[UIView alloc]initWithFrame:CGRectMake(KScreenW/2-50, 130, 100, 20)];
    _view1.backgroundColor = [UIColor colorWithRed:72/255.0 green:179/255.0 blue:249/255.0 alpha:1];
    [self.view addSubview:_view1];
    
    //圆点
    _labelCrile1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 10, 10)];
    _labelCrile1.layer.borderWidth = 1;
    _labelCrile1.layer.cornerRadius = 5;
    _labelCrile1.clipsToBounds = YES;
    _labelCrile1.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    _labelCrile2 = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 10, 10)];
    _labelCrile2.layer.borderWidth = 1;
    _labelCrile2.layer.cornerRadius = 5;
    _labelCrile2.clipsToBounds = YES;
    _labelCrile2.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    _labelCrile3 = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 10, 10)];
    _labelCrile3.layer.borderWidth = 1;
    _labelCrile3.layer.cornerRadius = 5;
    _labelCrile3.clipsToBounds = YES;
    _labelCrile3.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    _labelCrile4 = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 10, 10)];
    _labelCrile4.layer.borderWidth = 1;
    _labelCrile4.layer.cornerRadius = 5;
    _labelCrile4.clipsToBounds = YES;
    _labelCrile4.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    [_view1 addSubview:_labelCrile1];
    [_view1 addSubview:_labelCrile2];
    [_view1 addSubview:_labelCrile3];
    [_view1 addSubview:_labelCrile4];
    
    //弹出提示框
    _label1 = [[UILabel alloc]initWithFrame:CGRectMake(KScreenW/2-130, _tf.frame.origin.y+30, 250, 25)];
    _label1.textAlignment = NSTextAlignmentCenter;
    _label1.font = [UIFont systemFontOfSize:15];
    _label1.textColor = [UIColor whiteColor];
    _label1.layer.cornerRadius = 10;
    _label1.clipsToBounds = YES;
    _label1.center = CGPointMake(KScreenW/2, _tf.frame.origin.y+45);
    _label1.hidden =YES;
    [self.view addSubview:_label1];
    
    
    //忘记密码按钮
    UIButton *button =  [[UIButton alloc]initWithFrame:CGRectMake(30, KScreenH-60, 100, 200)];
    [button setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [self createCollectionViewKeyBoard];
}

- (void)createCollectionViewKeyBoard{
    _array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"",@"0",@"setting_safe_passcode_lock_del@3x"];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((KScreenW-40)/3, KScreenH/8);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 10;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 250, KScreenW, KScreenH/2) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"keyBoard_cell"];
    
    [self.view addSubview:_collectionView];
}

#pragma mark===代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"keyBoard_cell" forIndexPath:indexPath];
    
    if (indexPath.row == 11) {
        UIImageView *imV = [[UIImageView alloc]initWithFrame:CGRectMake((KScreenW-40)/6-20, KScreenH/16-15, 40,  30)];
        imV.image = [UIImage imageNamed:_array[indexPath.row]];
        [cell.contentView addSubview:imV];
        
    }else{
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (KScreenW-40)/3, KScreenH/8)];
        [cell.contentView addSubview:label];
        label.text =_array[indexPath.row];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor =[UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:30];
    }
    return cell;
}
//点击cell调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!(indexPath.row == 9 || indexPath.row == 11)) {
        NSString *number = _array[indexPath.row];
        if (_numberCount.length > 0) {
            _numberCount = [NSString stringWithFormat:@"%@%@",_numberCount,number];
            _tf.text = _numberCount;
        }
        if (_numberCount.length == 0) {
            _numberCount = number;
            _tf.text = _numberCount;
        }
    }
    if (indexPath.row ==11) {//点击删除 移除数组当中的最后一个元素
        if (_numberCount.length == 0) {
            _tf.text = nil;
        }else{
            _numberCount  = [_numberCount substringToIndex:_numberCount.length-1];
            _tf.text = _numberCount;
        }
    }
    [self changePassWordCircle];
}

- (void)changePassWordCircle{
    if (_tf.text.length == 0) {
        
        _labelCrile1.backgroundColor = [UIColor clearColor];
        _labelCrile2.backgroundColor = [UIColor clearColor];
        _labelCrile3.backgroundColor = [UIColor clearColor];
        _labelCrile4.backgroundColor = [UIColor clearColor];
    }
    if (_tf.text.length == 1) {
        _labelCrile1.backgroundColor = [UIColor whiteColor];
        _labelCrile2.backgroundColor = [UIColor clearColor];
        _labelCrile3.backgroundColor = [UIColor clearColor];
        _labelCrile4.backgroundColor = [UIColor clearColor];
    }
    if (_tf.text.length == 2) {
        _labelCrile1.backgroundColor = [UIColor whiteColor];
        _labelCrile2.backgroundColor = [UIColor whiteColor];
        _labelCrile3.backgroundColor = [UIColor clearColor];
        _labelCrile4.backgroundColor = [UIColor clearColor];
    }
    if (_tf.text.length == 3) {
        _labelCrile1.backgroundColor = [UIColor whiteColor];
        _labelCrile2.backgroundColor = [UIColor whiteColor];
        _labelCrile3.backgroundColor = [UIColor whiteColor];
        _labelCrile4.backgroundColor = [UIColor clearColor];
    }
    if (_tf.text.length == 4) {
        _labelCrile1.backgroundColor = [UIColor whiteColor];
        _labelCrile2.backgroundColor = [UIColor whiteColor];
        _labelCrile3.backgroundColor = [UIColor whiteColor];
        _labelCrile4.backgroundColor = [UIColor whiteColor];
        
        //读出用户设置的密码 与输入的密码比较
        NSUserDefaults *defdaults = [NSUserDefaults standardUserDefaults];
        NSString *string = [defdaults objectForKey:@"passWord"];
        
        if([_numberCount isEqualToString:string]){//如果相同
            //进入主程序
            _label1.hidden = YES;
            
        }else{
            [self compareSafePassWord];
        }
    }
}

//密码输入不一致
- (void)compareSafePassWord{
    --_errorCount;
    
    if (_errorCount > 0) {
        _tf.text = @"";
        _numberCount =@"";
        
        _labelCrile1.backgroundColor = [UIColor clearColor];
        _labelCrile2.backgroundColor = [UIColor clearColor];
        _labelCrile3.backgroundColor = [UIColor clearColor];
        _labelCrile4.backgroundColor = [UIColor clearColor];
        
        NSString *count = [NSString stringWithFormat:@"密码不正确，%ld次重试后需要重新登录",_errorCount];
        _label1.text = count;
        _label1.hidden = NO;
        //摇晃视图
        [self loadShakeAnimationForView:_view1];
        
    }else{
        //弹出提示框 重新登录
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:@"密码输入错误4次，是否重新登录账户" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *dissmiss = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //弹出登录界面
            
        }];
        
        [alertVC addAction:confirm];
        [alertVC addAction:dissmiss];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

//视图控件实现摇晃动画效果
-(void)loadShakeAnimationForView:(UIView*)view
{
    CALayer *layer = [view layer];
    CGPoint posLayer = [layer position];
    CGPoint y = CGPointMake(posLayer.x-10, posLayer.y);
    CGPoint x = CGPointMake(posLayer.x+10, posLayer.y);
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [layer addAnimation:animation forKey:nil];
}

@end
