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
    version = "2025.3.2.6"; # "Android Studio Panda 2 | 2025.3.2"
    sha256Hash = "sha256-MpQtjNdogZLPPNB78oL7EgA1ub2bVubxPFVA5tOYB+k=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2025.3.2.6/android-studio-panda2-linux.tar.gz";
  };
  betaVersion = {
    version = "2025.3.2.5"; # "Android Studio Panda 2 | 2025.3.2 RC 1"
    sha256Hash = "sha256-qpmc7MO48GV2nnxEdRstg3ne0Gvlrgk9UX5Dr60gAMM=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2025.3.2.5/android-studio-panda2-rc1-linux.tar.gz";
  };
  latestVersion = {
    version = "2025.3.3.2"; # "Android Studio Panda 3 | 2025.3.3 Canary 2"
    sha256Hash = "sha256-z8GpBqyEnbyyBc0XPo5q52WS5d7b4292QgUj0FPW+C0=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2025.3.3.2/android-studio-panda3-canary2-linux.tar.gz";
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
