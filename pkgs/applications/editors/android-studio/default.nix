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
    version = "2025.3.4.7"; # "Android Studio Panda 4 | 2025.3.4 Patch 1"
    sha256Hash = "sha256-qujzMvEkr9I8pJXcdwkVpFbadIDI+FngFTWtQvy0ygY=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2025.3.4.7/android-studio-panda4-patch1-linux.tar.gz";
  };
  betaVersion = {
    version = "2026.1.1.6"; # "Android Studio Quail 1 | 2026.1.1 RC 1"
    sha256Hash = "sha256-b6PVgBTTjIgm6BI171RL7T6GJD9ApnTWGOTqvt703PQ=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.1.6/android-studio-quail1-rc1-linux.tar.gz";
  };
  latestVersion = {
    version = "2026.1.2.2"; # "Android Studio Quail 2 | 2026.1.2 Canary 2"
    sha256Hash = "sha256-+FmW72k48GF71yzCdpIAl//qi6w26Qg8gZUW5/Nuh58=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.2.2/android-studio-quail2-canary2-linux.tar.gz";
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
