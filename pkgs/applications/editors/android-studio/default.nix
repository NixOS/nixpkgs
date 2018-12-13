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
    version = "3.3.0.18"; # "Android Studio 3.3 RC 2"
    build = "182.5160847";
    sha256Hash = "05rjwvcph0wx0p0hai5z6n9lnyhk3i5yvbvhr51jc8s3k3b6jyi5";
  };
  latestVersion = { # canary & dev
    version = "3.4.0.7"; # "Android Studio 3.4 Canary 8"
    build = "183.5173923";
    sha256Hash = "0bf96c9db15rw1k1znz6yxhbrn9q990zy3pkq0nsirnqfpgllvpi";
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
