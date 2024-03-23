{ callPackage, makeFontsConf, gnome2, buildFHSEnv, tiling_wm ? false }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
    inherit buildFHSEnv;
    inherit tiling_wm;
  };
  stableVersion = {
    version = "2023.2.1.24"; # "Android Studio Iguana | 2023.2.1 Patch 1"
    sha256Hash = "sha256-ACZCdXKEnJy7DJTW+XGOoIvDRdzP47NytUEAqV//mbU=";
  };
  betaVersion = {
    version = "2023.2.1.23"; # "Android Studio Iguana | 2023.2.1"
    sha256Hash = "sha256-G2aPgMqBHNw1DetlaBQ9o3/VfX6QEh9VQqMZ5S/VoHM=";
  };
  latestVersion = {
    version = "2023.3.2.1"; # "Android Studio Jellyfish | 2023.3.2 Canary 1"
    sha256Hash = "sha256-99EWGh3+3HV8yO29ANg1pwoo/1ktI2aCwKrdIqlcgVs=";
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
