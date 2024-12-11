{ callPackage, makeFontsConf, buildFHSEnv, tiling_wm ? false }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit buildFHSEnv;
    inherit tiling_wm;
  };
  stableVersion = {
    version = "2024.2.1.9"; # "Android Studio Ladybug | 2024.2.1"
    sha256Hash = "sha256-18ppVeAvxx6kNBOjSKcZjbEMNt8khKmohMq3JErX7pY=";
  };
  betaVersion = {
    version = "2024.2.1.8"; # "Android Studio Ladybug | 2024.2.1 RC 1"
    sha256Hash = "sha256-Kb/1+g9rIuU/pAO1ue5h0+BU7OCE09QqV9XFoiJxBL4=";
  };
  latestVersion = {
    version = "2024.3.1.2"; # "Android Studio Meerkat | 2024.3.1 Canary 2"
    sha256Hash = "sha256-Oy+BrRvySCAhlYAfaFdGMr//bfPJCfXJix7dp5ryTgg=";
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
