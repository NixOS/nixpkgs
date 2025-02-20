{ callPackage, makeFontsConf, buildFHSEnv, tiling_wm ? false }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit buildFHSEnv;
    inherit tiling_wm;
  };
  stableVersion = {
    version = "2024.2.2.14"; # "Android Studio Ladybug Feature Drop | 2024.2.2 Patch 1"
    sha256Hash = "sha256-c9t8GQw2azYIf4vyiKSolnbGTUeq25rYxSgBDei7I0Q=";
  };
  betaVersion = {
    version = "2024.3.1.11"; # "Android Studio Meerkat | 2024.3.1 RC 1"
    sha256Hash = "sha256-6nViPI61A9XJbKxsrbLrn2tiPKaqi6Mw9RIi49Sl+7M=";
  };
  latestVersion = {
    version = "2024.3.2.5"; # "Android Studio Meerkat Feature Drop | 2024.3.2 Canary 5"
    sha256Hash = "sha256-5HHUDZHIJkzx7iu89Ds/pjnsB2CBqz7VSUgb9VuqtKo=";
  };
in {
  # Attributes are named by their corresponding release channels

  stable = mkStudio (stableVersion // {
    channel = "stable";
    pname = "android-studio";
  });

  beta = mkStudio (betaVersion // {
    channel = "beta";
    pname = "android-studio-beta";
  });

  dev = mkStudio (latestVersion // {
    channel = "dev";
    pname = "android-studio-dev";
  });

  canary = mkStudio (latestVersion // {
    channel = "canary";
    pname = "android-studio-canary";
  });
}
