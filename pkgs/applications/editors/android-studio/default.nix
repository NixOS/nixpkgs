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
    version = "3.3.0.15"; # "Android Studio 3.3 Beta 3"
    build = "182.5105271";
    sha256Hash = "03j3g39v1g4jf5q37bd50zfqsgjfnwnyhjgx8vkfwlg263vhhvdq";
  };
  latestVersion = { # canary & dev
    version = "3.4.0.1"; # "Android Studio 3.4 Canary 2"
    build = "183.5081642";
    sha256Hash = "0ck6habkgnwbr10pr3bfy8ywm3dsm21k9jdj7g685v22sw0zy3yk";
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
