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
    version = "3.3.0.16"; # "Android Studio 3.3 Beta 4"
    build = "182.5114240";
    sha256Hash = "12gzwnlvc1w5lywpdckdgwxy2yrhf0m0fvaljdsis2arw0x9qdh2";
  };
  latestVersion = { # canary & dev
    version = "3.4.0.3"; # "Android Studio 3.4 Canary 4"
    build = "183.5129585";
    sha256Hash = "10y09sy0h4yp39dwpp8x7kjvw8r7hvk0qllbbaqj76j33xa85793";
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
