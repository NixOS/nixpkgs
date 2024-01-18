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
    version = "2023.1.1.27"; # "Android Studio Hedgehog | 2023.1.1 Patch 1"
    sha256Hash = "sha256-XF+XyHGk7dPTBHKcx929qdFHu6hRJWFO382mh4SuWDs=";
  };
  betaVersion = {
    version = "2023.2.1.20"; # "Android Studio Iguana | 2023.2.1 Beta 2"
    sha256Hash = "sha256-cFEPgFAKkFx0d7PC4fTElTQVrBZMQs0RL3wR+hqTh2I=";
  };
  latestVersion = {
    version = "2023.3.1.4"; # "Android Studio Jellyfish | 2023.3.1 Canary 4"
    sha256Hash = "sha256-txHkRZ87KnZvzbpBA19mZzQ0HKHWAJsSnNlQCUDsWmA=";
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
