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
    version = "3.4.0.15"; # "Android Studio 3.4 RC 1"
    build = "183.5341121";
    sha256Hash = "0s7wadnzbrd031ls43b5nbh1nx0paj74bxy2yiczr4qb9n562zzy";
  };
  latestVersion = { # canary & dev
    version = "3.5.0.5"; # "Android Studio 3.5 Canary 6"
    build = "183.5326993";
    sha256Hash = "06d43qw0p6zpy6vmriiihql5vgc6c4darplc2148y616hx0whrql";
  };
in rec {
  # Old alias (TODO @primeos: Remove after 19.03 is branched off):
  preview = throw ''
    The attributes "android-studio-preview" and "androidStudioPackages.preview"
    are now deprecated and will be removed soon, please use
    "androidStudioPackages.beta" instead. This attribute corresponds to the
    beta channel, if you want the latest release you can use
    "androidStudioPackages.dev" or "androidStudioPackages.canary" instead
    (currently, there is no difference between both channels).
  '';

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
