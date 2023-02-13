{ callPackage, makeFontsConf, gnome2, buildFHSUserEnv, tiling_wm ? false }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
    inherit buildFHSUserEnv;
    inherit tiling_wm;
  };
  stableVersion = {
    version = "2022.1.1.19"; # "Android Studio Electric Eel (2022.1.1)"
    sha256Hash = "luxE6a2C86JB28ezuIZV49TyE314S1RcNXQnCQamjUA=";
  };
  betaVersion = {
    version = "2022.2.1.12"; # "Android Studio Flamingo (2022.2.1) Beta 1"
    sha256Hash = "tIgmX9KiRInIupgIXWgg4dMf8bTwkVopOxAO5O1PUAc=";
  };
  latestVersion = { # canary & dev
    version = "2022.3.1.1"; # "Android Studio Girrafe (2022.3.1) Canary 1"
    sha256Hash = "I7Zc4DDByUB6XOnk7v+91ccpNI7eX/T4d3vH60ih8ec=";
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
