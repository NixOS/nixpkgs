{ callPackage, makeFontsConf, gnome2, buildFHSEnv, tiling_wm ? false }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
    inherit buildFHSEnv;
    inherit tiling_wm;
  };
  stableVersion = {
    version = "2022.3.1.19"; # "Android Studio Giraffe (2022.3.1)"
    sha256Hash = "sha256-JQYl3KsYPgxo6/Eu+KUir3NpUn128e/HBPk8BbAv+p4=";
  };
  betaVersion = {
    version = "2023.1.1.17"; # "Android Studio Hedgehog (2023.3.1)"
    sha256Hash = "sha256-0sN+B1RxxlbgxXrEs8gft4qjvIYtazJS6DllHZ2h768=";
  };
  latestVersion = {
    version = "2023.2.1.1"; # Android Studio Iguana (2023.2.1) Canary 1
    sha256Hash = "sha256-7ub9GkJd9J37nG2drXOuU7r4w/gI+m9nlWANqIk2ddk=";
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
