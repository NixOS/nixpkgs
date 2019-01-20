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
    version = "3.4.0.10"; # "Android Studio 3.4 Beta 1"
    build = "183.5217543";
    sha256Hash = "0yd9l4py82i3gl1nvfwlhfx12hzf1mih8ylgdl3r85hhlqs7w2dm";
  };
  latestVersion = { # canary & dev
    version = "3.5.0.0"; # "Android Studio 3.5 Canary 1"
    build = "183.5215047";
    sha256Hash = "1f7lllj85fia02hgy4ksbqh80sdcml16fv1g892jc6lwykjrdw5y";
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
