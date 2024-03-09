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
    version = "2023.2.1.23"; # "Android Studio Iguana | 2023.2.1"
    sha256Hash = "sha256-G2aPgMqBHNw1DetlaBQ9o3/VfX6QEh9VQqMZ5S/VoHM=";
  };
  betaVersion = {
    version = "2023.2.1.23"; # "Android Studio Iguana | 2023.2.1"
    sha256Hash = "sha256-G2aPgMqBHNw1DetlaBQ9o3/VfX6QEh9VQqMZ5S/VoHM=";
  };
  latestVersion = {
    version = "2023.3.1.12"; # "Android Studio Jellyfish | 2023.3.1 Canary 12"
    sha256Hash = "sha256-yg84WBLHfb6q+OlHuh5SJ5P4Fuc8yqO9eZ8iecOhZj4=";
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
