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
    version = "4.1.1.0"; # "Android Studio 4.1.1"
    build = "201.6953283";
    sha256Hash = "sha256-aAMhhJWcVFdvEZt8fI3tF12Eg3TzlU+kUFMNeCYN1os=";
  };
  betaVersion = {
    version = "4.1.0.18"; # "Android Studio 4.1 RC 3"
    build = "201.6823847";
    sha256Hash = "sha256-qbxmR9g8DSKzcP09bJuc+am79BSXWG39UQxFEb1bZ88=";
  };
  latestVersion = { # canary & dev
    version = "4.2.0.16"; # "Android Studio 4.2 Canary 16"
    build = "202.6939830";
    sha256Hash = "sha256-2Xh0GR4BHZI6ofdyMI2icrztI2BmiHWT+1bEZIZ58IE=";
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
