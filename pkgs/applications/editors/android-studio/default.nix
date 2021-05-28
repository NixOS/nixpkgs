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
    version = "4.1.0.19"; # "Android Studio 4.1.0"
    build = "201.6858069";
    sha256Hash = "sha256-S5Uh/EpjE61l/z4UsPP7UEJ9Rk/hQidVVWX0bg/60gI=";
  };
  betaVersion = {
    version = "4.1.0.18"; # "Android Studio 4.1 RC 3"
    build = "201.6823847";
    sha256Hash = "sha256-qbxmR9g8DSKzcP09bJuc+am79BSXWG39UQxFEb1bZ88=";
  };
  latestVersion = { # canary & dev
    version = "4.2.0.13"; # "Android Studio 4.2 Canary 13"
    build = "202.6863838";
    sha256Hash = "sha256-avkRelP5/sDXW7pdVrOknmb3PtR6XQEmQXivZFljpLc=";
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
