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
    version = "2025.2.3.6"; # "Android Studio Otter 3 Feature Drop | 2025.2.3 RC 1"
    sha256Hash = "sha256-UysTlKH2h+8FElFgYYTiP4LCPYCssMRSrSA4lwsk6ek=";
  };
  latestVersion = {
    version = "2025.3.1.1"; # "Android Studio Panda 1 | 2025.3.1 Canary 1"
    sha256Hash = "sha256-hCWt8wMxqA4So/oZL6RzRRY3Kg6vAYr9xDAzQ/5ZXow=";
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
