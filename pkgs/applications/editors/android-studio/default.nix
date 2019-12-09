{ callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.5.2.0"; # "Android Studio 3.5.2"
    build = "191.5977832";
    sha256Hash = "0kcd6kd5rn4b76damkfddin18d1r0dck05piv8mq1ns7x1n4hf7q";
  };
  betaVersion = {
    version = "3.6.0.17"; # "Android Studio 3.6 Beta 5"
    build = "192.6018865";
    sha256Hash = "0qlrdf7a6f5585mrni1aa2chic4n7b9c8lgrj8br6q929hc2f5d9";
  };
  latestVersion = { # canary & dev
    version = "4.0.0.4"; # "Android Studio 4.0 Canary 4"
    build = "192.6008643";
    sha256Hash = "1z1srginlg1xnp911nlilhf515mbpmngwhln29q6lxsir8g2cw2z";
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
