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
    version = "3.3.0.19"; # "Android Studio 3.3 RC 3"
    build = "182.5183351";
    sha256Hash = "1rql4kxjic4qjcd8zssw2mmi55cxpzd0wp5g0kzwk5wybsfdcqhy";
  };
  latestVersion = { # canary & dev
    version = "3.4.0.9"; # "Android Studio 3.4 Canary 10"
    build = "183.5202479";
    sha256Hash = "067mkf8n7bwv0f900d6d2hwxdhcgnp6dxqf6v81y1hf285ybymld";
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
