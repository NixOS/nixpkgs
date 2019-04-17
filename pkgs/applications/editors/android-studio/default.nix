{ stdenv, callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.3.2.0"; # "Android Studio 3.3.2"
    build = "182.5314842";
    sha256Hash = "0smh3d3v8n0isxg7fkls20622gp52f58i2b6wa4a0g8wnvmd6mw2";
  };
  betaVersion = {
    version = "3.4.0.17"; # "Android Studio 3.4 RC 3"
    build = "183.5400832";
    sha256Hash = "1v4apc73jdhavhzj8j46mzh15rw08w1hd9y9ykarj3b5q7i2vyq1";
  };
  latestVersion = { # canary & dev
    version = "3.5.0.10"; # "Android Studio 3.5 Canary 11"
    build = "191.5455988";
    sha256Hash = "1g24a8fwnrfzdf093wdmqly3mzjddk5ndgi51qj98amn7kclsdpf";
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
