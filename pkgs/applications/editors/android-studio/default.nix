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
    version = "3.2.0.25"; # "Android Studio 3.2 RC 3"
    build = "181.4987877";
    sha256Hash = "0mriakxxchc0wbqkl236pp4fsqbq3gb2qrkdg5hx9zz763dc59gp";
  };
  latestVersion = { # canary & dev
    version = "3.3.0.7"; # "Android Studio 3.3 Canary 8"
    build = "182.4978721";
    sha256Hash = "0xa19wrw1a6y7f2jdv8699yqv7g34h3zdw3wc0ql0447afzwg9a9";
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
