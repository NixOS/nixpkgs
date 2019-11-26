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
    version = "3.6.0.16"; # "Android Studio 3.6 Beta 4"
    build = "192.5994180";
    sha256Hash = "0wyyr6r0jzb1l4rn1mfgp0nnzvgk3x62imq629z6vrdbymy8psf1";
  };
  latestVersion = { # canary & dev
    version = "4.0.0.3"; # "Android Studio 4.0 Canary 3"
    build = "192.5994236";
    sha256Hash = "14ig352anjs0df72f41v4r6jl7mlm2n4pn9syanmykaj87dm4kf4";
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
