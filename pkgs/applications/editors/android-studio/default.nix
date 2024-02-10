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
    version = "2023.1.1.28"; # "Android Studio Hedgehog | 2023.1.1 Patch 2"
    sha256Hash = "sha256-E50Nu0kJNTto+/VcCbbTGjRRIESp1PAs4PGprMyhKPk=";
  };
  betaVersion = {
    version = "2023.2.1.21"; # "Android Studio Iguana | 2023.2.1 RC 1"
    sha256Hash = "sha256-TgBrgwsjJKBi4DfTMbcgmtoYfzQ3KGwn1zdEfKO9Q8k=";
  };
  latestVersion = {
    version = "2023.3.1.8"; # "Android Studio Jellyfish | 2023.3.1 Canary 8"
    sha256Hash = "sha256-wNduJ8AjLG+2gumFtLXYnzYiGN0sxL8WR2izWB87uMM=";
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
