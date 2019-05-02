{ stdenv, callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.4.0.18"; # "Android Studio 3.4.0"
    build = "183.5452501";
    sha256Hash = "0i8wz9v6nxzr27a07cv2330i84v94pcl13gjwvpglp55hyzd8axd";
  };
  betaVersion = stableVersion;
  latestVersion = { # canary & dev
    version = "3.5.0.12"; # "Android Studio 3.5 Canary 13"
    build = "191.5487692";
    sha256Hash = "0iwd2qa551rs9b0w4rs7wmzdbh3r4j76xvs815l6i5pilk0s47gz";
  };
in rec {
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
