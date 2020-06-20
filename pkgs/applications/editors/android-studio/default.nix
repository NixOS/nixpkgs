{ callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "4.0.0.16"; # "Android Studio 4.0"
    build = "193.6514223";
    sha256Hash = "1sqj64vddwfrr9821habfz7dms9csvbp7b8gf1d027188b2lvh3h";
  };
  betaVersion = {
    version = "4.0.0.16"; # "Android Studio 4.0"
    build = "193.6514223";
    sha256Hash = "1sqj64vddwfrr9821habfz7dms9csvbp7b8gf1d027188b2lvh3h";
  };
  latestVersion = { # canary & dev
    version = "4.1.0.10"; # "Android Studio 4.1 Canary 10"
    build = "201.6507185";
    sha256Hash = "19yawwsjsdqc0brr0ahviljv4v4p085k3izdpmm915c0bjm89y72";
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
