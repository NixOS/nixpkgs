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
    version = "2023.3.1.15"; # "Android Studio Jellyfish | 2023.3.1.1 Beta 2"
    sha256Hash = "sha256-ImXHda8Xbayuk+OMZVtAFsGNnaqm2PvI3lko2gUpIeU=";
  };
  latestVersion = {
    version = "2024.1.1.1"; # "Android Studio Koala | 2024.1.1 Canary 3"
    sha256Hash = "sha256-QNAudFlM+1QAZg+EYgiIknllai4N1wj55ZnkUWho7ps=";
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
