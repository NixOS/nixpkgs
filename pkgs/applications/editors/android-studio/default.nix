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
    version = "2022.3.1.18"; # "Android Studio Giraffe (2022.3.1)"
    sha256Hash = "sha256-JCFeEySmrJEYELLMGvstc1z3Rd+8BpGKQrjW+8a/dDM=";
  };
  betaVersion = {
    version = "2022.3.1.17"; # "Android Studio Giraffe (2022.3.1) RC 1"
    sha256Hash = "sha256-Bpur9ytiwa0udiyYVxlfLT4M+ZcO5atQUQg/ForATP4=";
  };
  latestVersion = {
    version = "2023.1.1.14"; # Android Studio Hedgehog (2023.1.1) Canary 14
    sha256Hash = "sha256-MgZDUpRyM0XDfgqfYjtJJyG2CBaNB06PgtoJltDwNwk=";
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
