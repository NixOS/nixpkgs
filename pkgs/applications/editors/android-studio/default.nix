{ stdenv, callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.3.1.0"; # "Android Studio 3.3.1"
    build = "182.5264788";
    sha256Hash = "0fghqkc8pkb7waxclm0qq4nlnsvmv9d3fcj5nnvgbfkjyw032q42";
  };
  betaVersion = {
    version = "3.4.0.13"; # "Android Studio 3.4 Beta 4"
    build = "183.5304277";
    sha256Hash = "01x7xba0f5js213wgw0h1vw297vwz5q7dprnilcdydfjxwqsbr8f";
  };
  latestVersion = { # canary & dev
    version = "3.5.0.3"; # "Android Studio 3.5 Canary 4"
    build = "183.5290690";
    sha256Hash = "0d1cl78b25pksaj0scv3hxb14bjxk3591zbc0v7dykk1gf4pvxd1";
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
