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
  betaVersion = latestVersion;
  latestVersion = { # canary & dev
    version = "3.5.0.13"; # "Android Studio 3.5 Beta 1"
    build = "191.5529924";
    sha256Hash = "0i710n2wr0a8lvxf1mg6a5pmdh1l72wa0hwyricyixi0mylwwc6l";
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
