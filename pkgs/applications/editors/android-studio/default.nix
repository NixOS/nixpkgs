{ callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.6.1.0"; # "Android Studio 3.6.1"
    build = "192.6241897";
    sha256Hash = "1mwzk18224bl8hbw9cdxwzgj5cfain4y70q64cpj4p0snffxqm77";
  };
  betaVersion = {
    version = "4.0.0.10"; # "Android Studio 4.0 Beta 1"
    build = "193.6220182";
    sha256Hash = "0ibp54wcss4ihm454hbavv1bhar6cd4alp5b0z248ryjr5w9mixf";
  };
  latestVersion = { # canary & dev
    version = "4.1.0.1"; # "Android Studio 4.1 Canary 1"
    build = "193.6224510";
    sha256Hash = "0misff7xx8jcg4zr5ahc8qdwvlkx605il0shzd9i1cm9v1br3sqx";
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
