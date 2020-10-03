{ callPackage, makeFontsConf, gnome2, buildFHSUserEnv }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
    inherit buildFHSUserEnv;
  };
  stableVersion = {
    version = "4.0.1.0"; # "Android Studio 4.0.1"
    build = "193.6626763";
    sha256Hash = "15vm7fvi8c286wx9f28z6ysvm8wqqda759qql0zy9simwx22gy7j";
  };
  betaVersion = {
    version = "4.1.0.18"; # "Android Studio 4.1 RC 3"
    build = "201.6823847";
    sha256Hash = "sha256-qbxmR9g8DSKzcP09bJuc+am79BSXWG39UQxFEb1bZ88=";
  };
  latestVersion = { # canary & dev
    version = "4.2.0.12"; # "Android Studio 4.2 Canary 12"
    build = "202.6847140";
    sha256Hash = "sha256-lt2069uAJdVlKg3fC2NmFFPoMmG5cAUnH9V4WRAawxk=";
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
