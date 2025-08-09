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
    version = "2025.1.2.10"; # "Android Studio Narwhal Feature Drop | 2025.1.2 RC 1"
    sha256Hash = "sha256-qA7iu4nK+29aHKsUmyQWuwV0SFnv5cYQvFq5CAMKyKw=";
  };
  latestVersion = {
    version = "2025.1.3.3"; # "Android Studio Narwhal Feature Drop | 2025.1.3 Canary 3"
    sha256Hash = "sha256-0BdbAJMQi9qgss1IJTMxjQpOjynLFuiY0Vlw5VYCY+c=";
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
