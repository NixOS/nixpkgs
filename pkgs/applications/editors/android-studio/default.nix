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
    version = "2026.1.3.8"; # "Android Studio Quail 3 | 2026.1.3 Patch 1"
    sha256Hash = "sha256-W9XuXW50exP4L7oyQTgL01jML0qEeBXI6GB1ffE9w18=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.3.8/android-studio-quail3-patch1-linux.tar.gz";
  };
  betaVersion = {
    version = "2026.1.3.6"; # "Android Studio Quail 3 | 2026.1.3 RC 2"
    sha256Hash = "sha256-Mgwy+Cbx5yBCHWUEcvMfAsC1zMk3j7A5fWtMrVJgmAk=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.3.6/android-studio-quail3-rc2-linux.tar.gz";
  };
  latestVersion = {
    version = "2026.1.4.4"; # "Android Studio Quail 4 | 2026.1.4 Canary 4"
    sha256Hash = "sha256-gcVlZzJ1/euSsKVrmYLXHt1Ym2kNghTzIk6crZXhGKQ=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.4.4/android-studio-quail4-canary4-linux.tar.gz";
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
