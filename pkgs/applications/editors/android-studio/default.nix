{ stdenv, callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.3.0.20"; # "Android Studio 3.3"
    build = "182.5199772";
    sha256Hash = "0dracganibnkyapn2pk2qqnxpwmii57371ycri4nccaci9v9pcjw";
  };
  betaVersion = {
    version = "3.4.0.12"; # "Android Studio 3.4 Beta 3"
    build = "183.5256591";
    sha256Hash = "1yab2sgabgk3wa3wrzv9z1dc2k7x0079v0mlwrp32jwx8r9byvcw";
  };
  latestVersion = { # canary & dev
    version = "3.5.0.2"; # "Android Studio 3.5 Canary 3"
    build = "183.5256920";
    sha256Hash = "09bd80ld21hq743xjacsq0nkxwl5xzr253p86n71n580yn4rgmlb";
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
