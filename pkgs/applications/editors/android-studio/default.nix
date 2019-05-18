{ stdenv, callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.4.1.0"; # "Android Studio 3.4.1"
    build = "183.5522156";
    sha256Hash = "0y4l9d1yrvv1csx6vl4jnqgqy96y44rl6p8hcxrnbvrg61iqnj30";
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
