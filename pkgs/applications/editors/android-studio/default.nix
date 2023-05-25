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
    version = "2022.2.1.19"; # "Android Studio Flamingo (2022.2.1) Patch 1"
    sha256Hash = "sha256-bAtPlJI3RwqQX6xpEi7S8T2IDc/39MONU3iFpfi8v3A=";
  };
  betaVersion = {
    version = "2022.3.1.12"; # "Android Studio Giraffe (2022.3.1) Beta 1"
    sha256Hash = "sha256-Wy5iifscL1Ko7ZInx/uAvyJyM4cS6LfTYWxdJbZk6po=";
  };
  latestVersion = betaVersion;
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
