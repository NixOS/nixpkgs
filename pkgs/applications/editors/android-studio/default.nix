{ stdenv, callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.2.0.26"; # "Android Studio 3.2.0"
    build = "181.5014246";
    sha256Hash = "0v1a3b0n8dq5p8f6jap2ypqw724v61ki31qhqmh9hn36mn6d8wg6";
  };
  betaVersion = stableVersion;
  latestVersion = { # canary & dev
    version = "3.3.0.12"; # "Android Studio 3.3 Canary 13"
    build = "182.5035453";
    sha256Hash = "0f2glxm41ci016dv9ygr12s72lc5mh0zsxhpmx0xswg9mdwrvwa7";
  };
in rec {
  # Old alias
  preview = beta;

  # Attributes are named by their corresponding release channels

  stable = mkStudio (stableVersion // {
    channel = "stable";
    pname = "android-studio";
  });

  beta = mkStudio (betaVersion // {
    channel = "beta";
    pname = "android-studio-preview";
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
