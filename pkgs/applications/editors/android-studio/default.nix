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
    version = "2026.1.1.10"; # "Android Studio Quail 1 | 2026.1.1 Patch 2"
    sha256Hash = "sha256-+9PxFtEsrtck6o2g0s2ufnkRcPefKqESc+oPLSKiJNw=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.1.10/android-studio-quail1-patch2-linux.tar.gz";
  };
  betaVersion = {
    version = "2026.1.2.8"; # "Android Studio Quail 2 | 2026.1.2 RC 1"
    sha256Hash = "sha256-tTMD3wgEg0W7WsJb/hWXMdzqNDD04uJ7imAzgWG9Jmc=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.2.8/android-studio-quail2-rc1-linux.tar.gz";
  };
  latestVersion = {
    version = "2026.1.3.1"; # "Android Studio Quail 3 | 2026.1.3 Canary 1"
    sha256Hash = "sha256-D7aSLkauEVB05/vhWxn7sfK2CoAzsvaxnkFViAuVIsc=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.3.1/android-studio-quail3-canary1-linux.tar.gz";
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
