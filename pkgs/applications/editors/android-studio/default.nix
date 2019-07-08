{ callPackage, makeFontsConf, gnome2 }:

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
  betaVersion = {
    version = "3.5.0.17"; # "Android Studio 3.5 Beta 5"
    build = "191.5675373";
    sha256Hash = "0iw9v2rzr32dhs3z4vgz93zvxcv111q4cvwzi2cb83hn8kl050ip";
  };
  latestVersion = { # canary & dev
    version = "3.6.0.3"; # "Android Studio 3.6 Canary 3"
    build = "191.5618338";
    sha256Hash = "0ryf61svn6ra8gh1rvfjqj3j282zmgcvkjvgfvql1wgkjlz21519";
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
