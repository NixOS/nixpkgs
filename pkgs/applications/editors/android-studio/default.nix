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
    version = "3.3.0.13"; # "Android Studio 3.3 Beta 1"
    build = "182.5073496";
    sha256Hash = "0bg1h0msd6mpkvirkg4pssa1ak32smv2rlxxsjdm3p29p8gg59px";
  };
  latestVersion = { # canary & dev
    version = "3.4.0.0"; # "Android Studio 3.4 Canary 1"
    build = "182.5070326";
    sha256Hash = "03h2yns8s9dqbbc9agxhidpmziy9g3z89nm3byydw43hdz54hxab";
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
