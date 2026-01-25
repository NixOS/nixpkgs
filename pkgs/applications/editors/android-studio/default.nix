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
    version = "2025.2.3.9"; # "Android Studio Otter 3 Feature Drop | 2025.2.3"
    sha256Hash = "sha256-mG6myss22nI/LIVQzM19jNPouLe7JEbTqL85u6+Rq8E=";
  };
  betaVersion = {
    version = "2025.2.3.8"; # "Android Studio Otter 3 Feature Drop | 2025.2.3 RC 3"
    sha256Hash = "sha256-KHvWVIxNzwdgl9kdqXD5Cpvz58r8pWs2VRyPV3VrJH0=";
  };
  latestVersion = {
    version = "2025.3.1.4"; # "Android Studio Panda 1 | 2025.3.1 Canary 4"
    sha256Hash = "sha256-5ymB/HKSmi32AWV39+HYmfY11frkNxf2dq8Ld4f9qfA=";
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
