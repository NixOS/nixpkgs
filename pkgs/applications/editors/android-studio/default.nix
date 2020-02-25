{ callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.6.0.21"; # "Android Studio 3.6"
    build = "192.6200805";
    sha256Hash = "1rf79fh6fbaxsj26q9bgl4vvmakv4wc0amjz026cm89hcwwzrb4d";
  };
  betaVersion = latestVersion;
  latestVersion = { # canary & dev
    version = "4.0.0.10"; # "Android Studio 4.0 Beta 1"
    build = "193.6220182";
    sha256Hash = "0ibp54wcss4ihm454hbavv1bhar6cd4alp5b0z248ryjr5w9mixf";
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
