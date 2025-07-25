//
//  SettingsViewController.m
//  BHTwitter
//
//  Created by BandarHelal
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (nonatomic, assign) BOOL hasDynamicSpecifiers;
@property (nonatomic, retain) NSMutableDictionary *dynamicSpecifiers;
@end

@implementation SettingsViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"BHInsta";
        [self.navigationController.navigationBar setPrefersLargeTitles:false];
    }
    return self;
}

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleInsetGrouped;
}

- (PSSpecifier *)newSectionWithTitle:(NSString *)header footer:(NSString *)footer {
    PSSpecifier *section = [PSSpecifier preferenceSpecifierNamed:header target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
    if (footer != nil) {
        [section setProperty:footer forKey:@"footerText"];
    }
    return section;
}
- (PSSpecifier *)newSwitchCellWithTitle:(NSString *)titleText detailTitle:(NSString *)detailText key:(NSString *)keyText defaultValue:(BOOL)defValue changeAction:(SEL)changeAction {
    PSSpecifier *switchCell = [PSSpecifier preferenceSpecifierNamed:titleText target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];

    [switchCell setProperty:keyText forKey:@"key"];
    [switchCell setProperty:keyText forKey:@"id"];
    [switchCell setProperty:@YES forKey:@"big"];
    [switchCell setProperty:BHSwitchTableCell.class forKey:@"cellClass"];
    [switchCell setProperty:NSBundle.mainBundle.bundleIdentifier forKey:@"defaults"];
    [switchCell setProperty:@(defValue) forKey:@"default"];
    [switchCell setProperty:NSStringFromSelector(changeAction) forKey:@"switchAction"];
    if (detailText != nil) {
        [switchCell setProperty:detailText forKey:@"subtitle"];
    }
    return switchCell;
}
- (PSSpecifier *)newButtonCellWithTitle:(NSString *)titleText detailTitle:(NSString *)detailText dynamicRule:(NSString *)rule action:(SEL)action {
    PSSpecifier *buttonCell = [PSSpecifier preferenceSpecifierNamed:titleText target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSButtonCell edit:nil];

    [buttonCell setButtonAction:action];
    [buttonCell setProperty:@YES forKey:@"big"];
    [buttonCell setProperty:BHButtonTableViewCell.class forKey:@"cellClass"];
    if (detailText != nil ){
        [buttonCell setProperty:detailText forKey:@"subtitle"];
    }
    if (rule != nil) {
        [buttonCell setProperty:@44 forKey:@"height"];
        [buttonCell setProperty:rule forKey:@"dynamicRule"];
    }
    return buttonCell;
}
- (PSSpecifier *)newHBLinkCellWithTitle:(NSString *)titleText detailTitle:(NSString *)detailText url:(NSString *)url {
    PSSpecifier *HBLinkCell = [PSSpecifier preferenceSpecifierNamed:titleText target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSButtonCell edit:nil];

    [HBLinkCell setButtonAction:@selector(hb_openURL:)];
    [HBLinkCell setProperty:HBLinkTableCell.class forKey:@"cellClass"];
    [HBLinkCell setProperty:url forKey:@"url"];
    if (detailText != nil) {
        [HBLinkCell setProperty:detailText forKey:@"subtitle"];
    }
    return HBLinkCell;
}
- (PSSpecifier *)newHBTwitterCellWithTitle:(NSString *)titleText twitterUsername:(NSString *)user customAvatarURL:(NSString *)avatarURL {
    PSSpecifier *TwitterCell = [PSSpecifier preferenceSpecifierNamed:titleText target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:1 edit:nil];

    [TwitterCell setButtonAction:@selector(hb_openURL:)];
    [TwitterCell setProperty:HBTwitterCell.class forKey:@"cellClass"];
    [TwitterCell setProperty:user forKey:@"user"];
    [TwitterCell setProperty:@YES forKey:@"big"];
    [TwitterCell setProperty:@56 forKey:@"height"];
    [TwitterCell setProperty:avatarURL forKey:@"iconURL"];
    return TwitterCell;
}
- (NSArray *)specifiers {
    if (!_specifiers) {

        PSSpecifier *feedSection = [self newSectionWithTitle:@"常规" footer:nil];
        PSSpecifier *mediaSection = [self newSectionWithTitle:@"保存媒体" footer:nil];
        PSSpecifier *storySection = [self newSectionWithTitle:@"快拍和信息" footer:nil];
        PSSpecifier *securitySection = [self newSectionWithTitle:@"安全" footer:nil];
        PSSpecifier *developer = [self newSectionWithTitle:@"开发者" footer:nil];

        PSSpecifier *hideAds = [self newSwitchCellWithTitle:@"移除广告" detailTitle:@"删除 Instagram 中所有广告" key:@"hide_ads" defaultValue:true changeAction:nil];
        PSSpecifier *noSuggestedPost = [self newSwitchCellWithTitle:@"移除推荐" detailTitle:@"删除动态中推荐的帖子" key:@"no_suggested_post" defaultValue:false changeAction:nil];
        PSSpecifier *showLikeCount = [self newSwitchCellWithTitle:@"显示点赞" detailTitle:@"在帖子中显示点赞数" key:@"show_like_count" defaultValue:true changeAction:nil];
        PSSpecifier *likeConfirmation = [self newSwitchCellWithTitle:@"点赞确认" detailTitle:@"当点“赞”时弹出确认弹窗" key:@"like_confirm" defaultValue:false changeAction:nil];
        PSSpecifier *followConfirmation = [self newSwitchCellWithTitle:@"关注确认" detailTitle:@"当点“关注”时弹出确认弹窗" key:@"follow_confirm" defaultValue:false changeAction:nil];
        PSSpecifier *copyDecription = [self newSwitchCellWithTitle:@"复制文案" detailTitle:@"长按复制怗子文案" key:@"copy_description" defaultValue:true changeAction:nil];
        PSSpecifier *copyBio = [self newSwitchCellWithTitle:@"复制简历" detailTitle:@"长按个人资料复制简历" key:@"copy_bio" defaultValue:true changeAction:nil];
        PSSpecifier *downloadVid = [self newSwitchCellWithTitle:@"下载视频" detailTitle:nil key:@"dw_videos" defaultValue:true changeAction:nil];
        PSSpecifier *profileSave = [self newSwitchCellWithTitle:@"保存图像" detailTitle:@"长按保存个人头像." key:@"save_profile" defaultValue:true changeAction:nil];

        PSSpecifier *disableAutoAdvance = [self newSwitchCellWithTitle:@"禁用自动播放" detailTitle:@"快拍中禁用自动播放下一个" key:@"disable_auto_advance" defaultValue:false changeAction:nil];
        PSSpecifier *keepDelMessage = [self newSwitchCellWithTitle:@"保留已删信息" detailTitle:@"保留私信聊天中已删除的消息" key:@"keep_deleted_message" defaultValue:true changeAction:nil];
        PSSpecifier *hideLastSeen = [self newSwitchCellWithTitle:@"禁用信息已读" detailTitle:@"允许私信聊天中磨名查看" key:@"remove_lastseen" defaultValue:false changeAction:nil];
        PSSpecifier *noScreenShotAlert = [self newSwitchCellWithTitle:@"删除截屏弹窗" detailTitle:nil key:@"remove_screenshot_alert" defaultValue:true changeAction:nil];
        PSSpecifier *unlimtedReply = [self newSwitchCellWithTitle:@"无限重播快拍" detailTitle:@"允许私信聊天中无限重播即时快拍" key:@"unlimited_replay" defaultValue:false changeAction:nil];
        PSSpecifier *noStorySeenReceipt = [self newSwitchCellWithTitle:@"快拍匿名查看" detailTitle:nil key:@"no_seen_receipt" defaultValue:false changeAction:nil];

        PSSpecifier *appLock = [self newSwitchCellWithTitle:@"密码锁定" detailTitle:@"密码锁定 Instagram，支持指纹或面容。" key:@"padlock" defaultValue:false changeAction:nil];

        // dvelopers section
        PSSpecifier *bandarHL = [self newHBTwitterCellWithTitle:@"开发者" twitterUsername:@"BandarHL" customAvatarURL:@"https://unavatar.io/twitter/BandarHL"];
        PSSpecifier *tipJar = [self newHBLinkCellWithTitle:@"捐赠" detailTitle:@"为插件开发做贡献" url:@"https://www.paypal.me/BandarHL"];
        PSSpecifier *sourcecode = [self newHBLinkCellWithTitle:@"代码开源" detailTitle:@"Github 上的 BHinsta 源代码" url:@"https://github.com/BandarHL/BHInstagram"];
        _specifiers = [NSMutableArray arrayWithArray:@[

            feedSection, // 1
            hideAds,
            noSuggestedPost,
            showLikeCount,
            likeConfirmation,
            followConfirmation,
            copyDecription,
            copyBio,

            mediaSection, // 2
            downloadVid,
            profileSave,

            storySection, // 3
            keepDelMessage,
            disableAutoAdvance,
            hideLastSeen,
            noScreenShotAlert,
            unlimtedReply,
            noStorySeenReceipt,

            securitySection, // 4
            appLock,

            developer, // 5
            bandarHL,
            tipJar,
            sourcecode,
            
        ]];

        [self collectDynamicSpecifiersFromArray:_specifiers];
    }

    return _specifiers;
}
- (void)reloadSpecifiers {
    [super reloadSpecifiers];

    [self collectDynamicSpecifiersFromArray:self.specifiers];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasDynamicSpecifiers) {
        PSSpecifier *dynamicSpecifier = [self specifierAtIndexPath:indexPath];
        BOOL __block shouldHide = false;

        [self.dynamicSpecifiers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSMutableArray *specifiers = obj;
            if ([specifiers containsObject:dynamicSpecifier]) {
                shouldHide = [self shouldHideSpecifier:dynamicSpecifier];

                UITableViewCell *specifierCell = [dynamicSpecifier propertyForKey:PSTableCellKey];
                specifierCell.clipsToBounds = shouldHide;
            }
        }];
        if (shouldHide) {
            return 0;
        }
    }

    return UITableViewAutomaticDimension;
}

- (void)collectDynamicSpecifiersFromArray:(NSArray *)array {
    if (!self.dynamicSpecifiers) {
        self.dynamicSpecifiers = [NSMutableDictionary new];

    } else {
        [self.dynamicSpecifiers removeAllObjects];
    }

    for (PSSpecifier *specifier in array) {
        NSString *dynamicSpecifierRule = [specifier propertyForKey:@"dynamicRule"];

        if (dynamicSpecifierRule.length > 0) {
            NSArray *ruleComponents = [dynamicSpecifierRule componentsSeparatedByString:@", "];

            if (ruleComponents.count == 3) {
                NSString *opposingSpecifierID = [ruleComponents objectAtIndex:0];
                if ([self.dynamicSpecifiers objectForKey:opposingSpecifierID]) {
                    NSMutableArray *specifiers = [[self.dynamicSpecifiers objectForKey:opposingSpecifierID] mutableCopy];
                    [specifiers addObject:specifier];


                    [self.dynamicSpecifiers removeObjectForKey:opposingSpecifierID];
                    [self.dynamicSpecifiers setObject:specifiers forKey:opposingSpecifierID];
                } else {
                    [self.dynamicSpecifiers setObject:[NSMutableArray arrayWithArray:@[specifier]] forKey:opposingSpecifierID];
                }

            } else {
                [NSException raise:NSInternalInconsistencyException format:@"dynamicRule key requires three components (Specifier ID, Comparator, Value To Compare To). You have %ld of 3 (%@) for specifier '%@'.", ruleComponents.count, dynamicSpecifierRule, [specifier propertyForKey:PSTitleKey]];
            }
        }
    }

    self.hasDynamicSpecifiers = (self.dynamicSpecifiers.count > 0);
}
- (DynamicSpecifierOperatorType)operatorTypeForString:(NSString *)string {
    NSDictionary *operatorValues = @{ @"==" : @(EqualToOperatorType), @"!=" : @(NotEqualToOperatorType), @">" : @(GreaterThanOperatorType), @"<" : @(LessThanOperatorType) };
    return [operatorValues[string] intValue];
}
- (BOOL)shouldHideSpecifier:(PSSpecifier *)specifier {
    if (specifier) {
        NSString *dynamicSpecifierRule = [specifier propertyForKey:@"dynamicRule"];
        NSArray *ruleComponents = [dynamicSpecifierRule componentsSeparatedByString:@", "];

        PSSpecifier *opposingSpecifier = [self specifierForID:[ruleComponents objectAtIndex:0]];
        id opposingValue = [self readPreferenceValue:opposingSpecifier];
        id requiredValue = [ruleComponents objectAtIndex:2];

        if ([opposingValue isKindOfClass:NSNumber.class]) {
            DynamicSpecifierOperatorType operatorType = [self operatorTypeForString:[ruleComponents objectAtIndex:1]];

            switch (operatorType) {
                case EqualToOperatorType:
                    return ([opposingValue intValue] == [requiredValue intValue]);
                    break;

                case NotEqualToOperatorType:
                    return ([opposingValue intValue] != [requiredValue intValue]);
                    break;

                case GreaterThanOperatorType:
                    return ([opposingValue intValue] > [requiredValue intValue]);
                    break;

                case LessThanOperatorType:
                    return ([opposingValue intValue] < [requiredValue intValue]);
                    break;
            }
        }

        if ([opposingValue isKindOfClass:NSString.class]) {
            return [opposingValue isEqualToString:requiredValue];
        }

        if ([opposingValue isKindOfClass:NSArray.class]) {
            return [opposingValue containsObject:requiredValue];
        }
    }

    return NO;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    NSUserDefaults *Prefs = [NSUserDefaults standardUserDefaults];
    [Prefs setValue:value forKey:[specifier identifier]];

    if (self.hasDynamicSpecifiers) {
        NSString *specifierID = [specifier propertyForKey:PSIDKey];
        PSSpecifier *dynamicSpecifier = [self.dynamicSpecifiers objectForKey:specifierID];

        if (dynamicSpecifier) {
            [self.table beginUpdates];
            [self.table endUpdates];
        }
    }
}
- (id)readPreferenceValue:(PSSpecifier *)specifier {
    NSUserDefaults *Prefs = [NSUserDefaults standardUserDefaults];
    return [Prefs valueForKey:[specifier identifier]]?:[specifier properties][@"default"];
}
@end

@implementation BHButtonTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier specifier:specifier];
    if (self) {
        NSString *subTitle = [specifier.properties[@"subtitle"] copy];
        BOOL isBig = specifier.properties[@"big"] ? ((NSNumber *)specifier.properties[@"big"]).boolValue : NO;
        self.detailTextLabel.text = subTitle;
        self.detailTextLabel.numberOfLines = isBig ? 0 : 1;
        self.detailTextLabel.textColor = [UIColor secondaryLabelColor];
    }
    return self;
}

@end

@implementation BHSwitchTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier specifier:specifier])) {
        NSString *subTitle = [specifier.properties[@"subtitle"] copy];
        BOOL isBig = specifier.properties[@"big"] ? ((NSNumber *)specifier.properties[@"big"]).boolValue : NO;
        self.detailTextLabel.text = subTitle;
        self.detailTextLabel.numberOfLines = isBig ? 0 : 1;
        self.detailTextLabel.textColor = [UIColor secondaryLabelColor];

        if (specifier.properties[@"switchAction"]) {
            UISwitch *targetSwitch = ((UISwitch *)[self control]);
            NSString *strAction = [specifier.properties[@"switchAction"] copy];
            [targetSwitch addTarget:[self cellTarget] action:NSSelectorFromString(strAction) forControlEvents:UIControlEventValueChanged];
        }
    }
    return self;
}
@end
