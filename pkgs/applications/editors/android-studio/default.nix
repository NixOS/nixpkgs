{ stdenv, callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.1.4.0"; # "Android Studio 3.1.4"
    build = "173.4907809";
    sha256Hash = "0xx6yprylmcb32ipmwdcfkgddlm1nrxi1w68miclvgrbk015brf2";
  };
  betaVersion = {
    version = "3.2.0.22"; # "Android Studio 3.2 Beta 5"
    build = "181.4913314";
    sha256Hash = "016nyn1pqviy089hg0dq7m4cqb39fdxdcy4zknkaq7dmgv1dj6x9";
  };
  latestVersion = { # canary & dev
    version = "3.3.0.5"; # "Android Studio 3.3 Canary 6"
    build = "182.4954005";
    sha256Hash = "0b8ias75f3p5nrmgp7iqz4n4r4dbwhgagqmyc1fqfd36wbglyaf4";
  };
in rec {
  # Old alias
  preview = beta;

  # Attributes are named by their corresponding release channels

  stable = mkStudio (stableVersion // {
    channel = "stable";
    pname = "android-studio";
  });

  beta = mkStudio (betaVersion // {
    channel = "beta";
    pname = "android-studio-preview";
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
