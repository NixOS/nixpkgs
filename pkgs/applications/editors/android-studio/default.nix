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
    version = "3.6.0.14"; # "Android Studio 3.6 Beta 2"
    build = "192.5947919";
    sha256Hash = "09l7mdjkzwnkkcgxp0x66bzm125ignrfssy7n141wvs2rd66i2fs";
  };
  latestVersion = { # canary & dev
    version = "4.0.0.1"; # "Android Studio 4.0 Canary 1"
    build = "192.5959023";
    sha256Hash = "1d9hvyk0wnfiip1612ci4sbw58rq93cyy026cx6s33rvjk3cwfrl";
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
