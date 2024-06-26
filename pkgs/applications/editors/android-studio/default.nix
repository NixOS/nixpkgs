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
    version = "2024.1.1.11"; # "Android Studio Koala | 2024.1.1"
    sha256Hash = "sha256-2PqOz+QVtEUTNQkBUB4qD0KcoDPPGAUFSxyBbEpwRWU=";
  };
  betaVersion = {
    version = "2024.1.1.10"; # "Android Studio Koala | 2024.1.1 RC 2"
    sha256Hash = "sha256-84CpZfoAvJHUCO3ZBJqDbuz9xuGE/5xJfXoetJDXju8=";
  };
  latestVersion = {
    version = "2024.1.2.7"; # "Android Studio Koala Feature Drop | 2024.1.2 Canary 7"
    sha256Hash = "sha256-opoAKslh8DqS/iS5gw8AxX6x89t2BNX7yaU88XNd2kM=";
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
