{ callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.6.1.0"; # "Android Studio 3.6.1"
    build = "192.6241897";
    sha256Hash = "1mwzk18224bl8hbw9cdxwzgj5cfain4y70q64cpj4p0snffxqm77";
  };
  betaVersion = {
    version = "4.0.0.12"; # "Android Studio 4.0 Beta 3"
    build = "193.6296804";
    sha256Hash = "072rvh20xkn7izh6f2r2bspy06jrvcibj2hc12hz76m8cwzf4v0m";
  };
  latestVersion = { # canary & dev
    version = "4.1.0.4"; # "Android Studio 4.1 Canary 4"
    build = "193.6325121";
    sha256Hash = "19b4a03qfljdisn7cw44qzab85hib000m9mgswzssjh6ylkd9arw";
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
