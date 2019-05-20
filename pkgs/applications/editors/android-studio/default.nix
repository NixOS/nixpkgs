{ stdenv, callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.4.1.0"; # "Android Studio 3.4.1"
    build = "183.5522156";
    sha256Hash = "0y4l9d1yrvv1csx6vl4jnqgqy96y44rl6p8hcxrnbvrg61iqnj30";
  };
  betaVersion = latestVersion;
  latestVersion = { # canary & dev
    version = "3.5.0.14"; # "Android Studio 3.5 Beta 2"
    build = "191.5549111";
    sha256Hash = "1zy2x0m1nsx3yy64cp1jvgb9aqkribwm64mv50g9355sdz7qjhcf";
  };
in rec {
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
