{ callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.6.3.0"; # "Android Studio 3.6.3"
    build = "192.6392135";
    sha256Hash = "0apxmp341m7mbpm2df3qvsbaifwy6yqq746kbhbwlw8bn9hrzv1k";
  };
  betaVersion = {
    version = "4.0.0.14"; # "Android Studio 4.0 Beta 5"
    build = "193.6401094";
    sha256Hash = "11fmpf58z44i78ldkapzivz6md65744vqczzbwv8mkjkv9nz95rs";
  };
  latestVersion = { # canary & dev
    version = "4.1.0.8"; # "Android Studio 4.1 Canary 8"
    build = "193.6423924";
    sha256Hash = "0ksgmhz9vhkw2mxzjapli0w6203ssd8ddgb0dq06rck8v7ysy8bp";
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
