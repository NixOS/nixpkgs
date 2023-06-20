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
    version = "2022.2.1.20"; # "Android Studio Flamingo (2022.2.1) Patch 2"
    sha256Hash = "sha256-X+ZuH4cHKfQtfvOF0kLk+QjQ5AR3pTEparczHEUk+uY=";
  };
  betaVersion = {
    version = "2022.3.1.16"; # "Android Studio Giraffe (2022.3.1) Beta 5"
    sha256Hash = "sha256-D+Hoa50fzvtO0/6DsExmGSDzcgDIT2Bg+HvI6mCle14=";
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
