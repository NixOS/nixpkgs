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
    version = "2024.2.2.13"; # "Android Studio Ladybug Feature Drop | 2024.2.2"
    sha256Hash = "sha256-t/4e1KeVm9rKeo/VdGHbv5ogXrI8whjtgo7YjouZjLU=";
  };
  betaVersion = {
    version = "2024.2.2.12"; # "Android Studio Ladybug Feature Drop | 2024.2.2 RC 2"
    sha256Hash = "sha256-zfiTjyD2bMIJ+GVQyg7qUT7306roqYsdRkPECZ/Rdnc=";
  };
  latestVersion = {
    version = "2024.3.1.9"; # "Android Studio Meerkat | 2024.3.1 Canary 9"
    sha256Hash = "sha256-6h10j5siu3uHdb0K+cS2ctKulJ32BfaYWweAyR2DfRE=";
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
