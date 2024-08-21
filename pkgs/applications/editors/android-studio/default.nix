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
    version = "2024.1.1.12"; # "Android Studio Koala | 2024.1.1 Patch 1"
    sha256Hash = "sha256-Qvi/Mc4NEk3dERlfZiowBk2Pmqsgbl5mg56HamvG7aI=";
  };
  betaVersion = {
    version = "2024.1.2.10"; # "Android Studio Koala Feature Drop | 2024.1.2 Beta 2"
    sha256Hash = "sha256-/LrHYyrOPfnSliM5XUOzENjJ+G+M1Ajw31tFAOsbfnQ=";
  };
  latestVersion = {
    version = "2024.1.3.3"; # "Android Studio Ladybug | 2024.1.3 Canary 3"
    sha256Hash = "sha256-Ps3jMtNAdfPitFeXIFKpjSyM4si4tp4MrS3r5VURFh4=";
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
