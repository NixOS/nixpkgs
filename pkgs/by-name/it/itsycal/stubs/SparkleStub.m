#import "Sparkle/SUUpdater.h"

@implementation SUUpdater

+ (instancetype)sharedUpdater {
    static SUUpdater *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[SUUpdater alloc] init];
    });
    return shared;
}

- (void)checkForUpdates:(id)sender {}

@end
