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
    version = "3.4.0.16"; # "Android Studio 3.4 RC 2"
    build = "183.5370308";
    sha256Hash = "0d7d6n7n1zzhxpdykbwwbrw139mqxkp20d4l0570pk7975p1s2q9";
  };
  latestVersion = { # canary & dev
    version = "3.5.0.6"; # "Android Studio 3.5 Canary 7"
    build = "183.5346365";
    sha256Hash = "0dfkhzsxabrv8cwgyv3gicpglgpccmi1ig5shlhp6a006awgfyj0";
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
