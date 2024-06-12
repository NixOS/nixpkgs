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
    version = "2023.3.1.19"; # "Android Studio Jellyfish | 2023.3.1 Patch 1"
    sha256Hash = "sha256-FyscJPusmK33UPIexV20GXQ4Z5X8mfNRFPu/2Xeg5ts=";
  };
  betaVersion = {
    version = "2023.3.1.17"; # "Android Studio Jellyfish | 2023.3.1.1 RC 2"
    sha256Hash = "sha256-zROBKzQiP4V2P67HgOIkHgn8q/M0zy5MkZozVSiQsWU=";
  };
  latestVersion = {
    version = "2024.1.1.4"; # "Android Studio Koala | 2024.1.1 Canary 6"
    sha256Hash = "sha256-lfig7lFyF7XZowTQKpo6zGeR23VHq/f7vvUDWCs7jeo=";
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
