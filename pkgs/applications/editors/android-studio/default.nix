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
  betaVersion = {
    version = "3.5.0.16"; # "Android Studio 3.5 Beta 4"
    build = "191.5619324";
    sha256Hash = "1rg6v9b8fdnmslpv80khhpx59lvwhj1vwbkyabz2fryfj67wz01z";
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
