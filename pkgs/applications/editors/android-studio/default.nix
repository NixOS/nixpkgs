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
    version = "2025.3.3.7"; # "Android Studio Panda 3 | 2025.3.3 Patch 1"
    sha256Hash = "sha256-FTAJ9rZPwLgIA/uPKl4d9haBxLL4O2Z+H8sY6RqaeOA=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2025.3.3.7/android-studio-panda3-patch1-linux.tar.gz";
  };
  betaVersion = {
    version = "2025.3.4.5"; # "Android Studio Panda 4 | 2025.3.4 RC 1"
    sha256Hash = "sha256-NiNq1j+rzPU4KsLKYymfi5/Vx2Bn3hK8I3OVIUFloX0=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2025.3.4.5/android-studio-panda4-rc1-linux.tar.gz";
  };
  latestVersion = {
    version = "2025.3.4.4"; # "Android Studio Panda 4 | 2025.3.4 Canary 4"
    sha256Hash = "sha256-sPGJuOm5T7EZV5hhOJsZc7P8CTXyv9A6k82hM1GZGpY=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2025.3.4.4/android-studio-panda4-canary4-linux.tar.gz";
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
