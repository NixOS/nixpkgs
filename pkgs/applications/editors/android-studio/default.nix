{ stdenv, callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.2.1.0"; # "Android Studio 3.2.1"
    build = "181.5056338";
    sha256Hash = "117skqjax1xz9plarhdnrw2rwprjpybdc7mx7wggxapyy920vv5r";
  };
  betaVersion = {
    version = "3.3.0.17"; # "Android Studio 3.3 RC 1"
    build = "182.5138683";
    sha256Hash = "0apc566l4gwkwvfgj50d4qxm2gw26rxdlyr8kj3kfcra9a33c2b7";
  };
  latestVersion = { # canary & dev
    version = "3.4.0.5"; # "Android Studio 3.4 Canary 6"
    build = "183.5146016";
    sha256Hash = "1z2asimpsw15iild7c4aqicph6v327qx3ffjgvl2n8vr5rspsns1";
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
