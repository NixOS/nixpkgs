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
    version = "3.6.0.15"; # "Android Studio 3.6 Beta 3"
    build = "192.5982640";
    sha256Hash = "0017g7nvjiadd64in9fl4wq5lf8b7pyrdasbnwzjcphpbzy1390x";
  };
  latestVersion = { # canary & dev
    version = "4.0.0.2"; # "Android Studio 4.0 Canary 2"
    build = "192.5984562";
    sha256Hash = "0p29a6np31396970lnb3di2yrcqi3z8nqcn27hcnb4c4g7kjm0qw";
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
