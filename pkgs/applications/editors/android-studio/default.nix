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
    version = "2025.1.1.14"; # "Android Studio Narwhal | 2025.1.1 Patch 1"
    sha256Hash = "sha256-rTZOvLl1Lqc0zXNiTmVoMnLEAwWOEDW5MJg8ysiiyBo=";
  };
  betaVersion = {
    version = "2025.1.1.12"; # "Android Studio Narwhal | 2025.1.1 RC 2"
    sha256Hash = "sha256-mqQM39PePFYWIgukzN3X4rTHPUcdrFTc/OC9w4t+wJM=";
  };
  latestVersion = {
    version = "2025.1.2.8"; # "Android Studio Narwhal Feature Drop | 2025.1.2 Canary 8"
    sha256Hash = "sha256-p7sIraR5MbFqr2svD1GKR71I0U1UDMkmAW4PAHjWyD4=";
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
