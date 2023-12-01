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
    version = "2022.3.1.20"; # "Android Studio Giraffe (2022.3.1) Patch 2"
    sha256Hash = "sha256-IkxOt6DI4cBPUOztEBNJV0DHGruJjVdJ0skxcue+rdg=";
  };
  betaVersion = {
    version = "2023.1.1.25"; # "Android Studio Hedgehog | 2023.1.1 RC 3"
    sha256Hash = "sha256-jOqTAHYAk8j9+Ir01TLBsp20u7/iBKV8T/joZLITDs4=";
  };
  latestVersion = {
    version = "2023.2.1.14"; # "Android Studio Iguana | 2023.2.1 Canary 14"
    sha256Hash = "sha256-8szERftch1JWJ66BclJBq5DZcH1Xf1cyVj08WknLoS8=";
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
