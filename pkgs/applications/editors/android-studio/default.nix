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
    version = "2021.1.1.23"; # "Android Studio Bumblebee (2021.1.1 Patch 3)"
    sha256Hash = "1kxb19qf7bs5lyfgr8vamakp1nf2wlxlwwni1kihza67ib6hcxdk";
  };
  betaVersion = {
    version = "2021.2.1.11"; # "Android Studio Chipmunk (2021.2.1) Beta 4"
    sha256Hash = "0in8x6v957y9hsnz5ak845pdpvgvnvlm0s6r9y8f27zkm947vbjd";
  };
  latestVersion = { # canary & dev
    version = "2021.3.1.7"; # "Android Studio Dolphin (2021.3.1) Canary 7"
    sha256Hash = "02jwy3q2ccs7l3snm8w40znzk54v2h1sljdr3d0yh7sy0qyn32k1";
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
