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
    version = "2025.2.1.8"; # "Android Studio Otter | 2025.2.1 Patch 1"
    sha256Hash = "sha256-eqai5G60OH3vH06iK4tKK2gCHvqFBlNHxBGHQ5/SUJY=";
  };
  betaVersion = {
    version = "2025.2.2.5"; # "Android Studio Otter 2 Feature Drop | 2025.2.2 RC 1"
    sha256Hash = "sha256-Z6HV0kx/28cn5IdUxQCWI5mhc8IIG64+9SAOzjzwcuI=";
  };
  latestVersion = {
    version = "2025.2.3.1"; # "Android Studio Otter 3 Feature Drop | 2025.2.3 Canary 1"
    sha256Hash = "sha256-OHUKe2FBaxql3bS9kxrM8SSsSt6UpNYoZpkiPWfpafA=";
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
