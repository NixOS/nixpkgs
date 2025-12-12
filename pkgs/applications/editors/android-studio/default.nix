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
    version = "2025.2.2.7"; # "Android Studio Otter 2 Feature Drop | 2025.2.2"
    sha256Hash = "sha256-pvnUDYeFbxOnw2dP9BeKFushnTHmpDrBwmnNWDx8pbQ=";
  };
  betaVersion = {
    version = "2025.2.2.6"; # "Android Studio Otter 2 Feature Drop | 2025.2.2 RC 2"
    sha256Hash = "sha256-ciu+To5Kcus8FPDz1D43AD+qOqfPHaW4JsEBr9fx2PE=";
  };
  latestVersion = {
    version = "2025.2.3.4"; # "Android Studio Otter 3 Feature Drop | 2025.2.3 Canary 4"
    sha256Hash = "sha256-Oi+sGK8d7ms/BYt7F9xwEFGPdQUEHhfdclKQi9vAxgU=";
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
