{
  callPackage,
  makeFontsConf,
  buildFHSEnv,
  tiling_wm ? false,
}:

let
  mkStudio =
    opts:
    callPackage (import ./common.nix opts) {
      fontsConf = makeFontsConf {
        fontDirectories = [ ];
      };
      inherit buildFHSEnv;
      inherit tiling_wm;
    };
  stableVersion = {
    version = "2026.1.2.11"; # "Android Studio Quail 2 | 2026.1.2 Patch 1"
    sha256Hash = "sha256-HMnNVPQA27DQeITw98DKtSTbXOCl73CyOu1v3TzURbk=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.2.11/android-studio-quail2-patch1-linux.tar.gz";
  };
  betaVersion = {
    version = "2026.1.3.5"; # "Android Studio Quail 3 | 2026.1.3 RC 1"
    sha256Hash = "sha256-P8YoUnG4YtCOPkbHLFBHfteZg8cJJeXuDgty+kmgbSw=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.3.5/android-studio-quail3-rc1-linux.tar.gz";
  };
  latestVersion = {
    version = "2026.1.4.1"; # "Android Studio Quail 4 | 2026.1.4 Canary 1"
    sha256Hash = "sha256-ynHUoMDsTNgKKRAU948k37ktAIlIm9A+md8KyVBTjl4=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.4.1/android-studio-quail4-canary1-linux.tar.gz";
  };
in
{
  # Attributes are named by their corresponding release channels

  stable = mkStudio (
    stableVersion
    // {
      channel = "stable";
      pname = "android-studio";
    }
  );

  beta = mkStudio (
    betaVersion
    // {
      channel = "beta";
      pname = "android-studio-beta";
    }
  );

  dev = mkStudio (
    latestVersion
    // {
      channel = "dev";
      pname = "android-studio-dev";
    }
  );

  canary = mkStudio (
    latestVersion
    // {
      channel = "canary";
      pname = "android-studio-canary";
    }
  );
}
