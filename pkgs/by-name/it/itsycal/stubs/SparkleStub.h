#import <Foundation/Foundation.h>

@interface SUUpdater : NSObject

@property (nonatomic) BOOL automaticallyChecksForUpdates;

+ (instancetype)sharedUpdater;
- (void)checkForUpdates:(id)sender;

@end
