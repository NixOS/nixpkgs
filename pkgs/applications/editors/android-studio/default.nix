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
    version = "2023.1.1.26"; # "Android Studio Hedgehog | 2023.1.1"
    sha256Hash = "sha256-l36KmFVBT31BFX8L4OEPt0DEK9M392PV2Ws+BZeAZj0=";
  };
  betaVersion = {
    version = "2023.2.1.19"; # "Android Studio Iguana | 2023.2.1 Beta 1"
    sha256Hash = "sha256-lfJBX7RLIziiuv805+gdt8xfJkFjy0bSh77/bjkNFH4=";
  };
  latestVersion = {
    version = "2023.2.1.18"; # "Android Studio Iguana | 2023.2.1 Canary 18"
    sha256Hash = "sha256-QvyA/1IvqIgGkBWryY0Q7LqGA6I1f9Xn8GA1g19jt+w=";
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
