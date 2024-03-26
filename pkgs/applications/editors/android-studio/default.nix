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
    version = "2023.3.1.14"; # "Android Studio Jellyfish | 2023.3.1.1 Beta 1"
    sha256Hash = "sha256-2p/WwH6yPAMwUSJ5NrWvJBZG395eS9UgApFr/CB1fUo=";
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
