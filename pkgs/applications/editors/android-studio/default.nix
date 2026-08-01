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
    version = "2026.1.3.7"; # "Android Studio Quail 3 | 2026.1.3"
    sha256Hash = "sha256-NoMhIlV6tzymjf2b2YndrEAQOsADyhDgTJSaH2FXimc=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.3.7/android-studio-quail3-linux.tar.gz";
  };
  betaVersion = {
    version = "2026.1.3.6"; # "Android Studio Quail 3 | 2026.1.3 RC 2"
    sha256Hash = "sha256-Mgwy+Cbx5yBCHWUEcvMfAsC1zMk3j7A5fWtMrVJgmAk=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.3.6/android-studio-quail3-rc2-linux.tar.gz";
  };
  latestVersion = {
    version = "2026.1.4.2"; # "Android Studio Quail 4 | 2026.1.4 Canary 2"
    sha256Hash = "sha256-+63P62l4E+q7V4n/M3R3jGOrod9OkTDic/FMA5L5pMk=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.4.2/android-studio-quail4-canary2-linux.tar.gz";
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
