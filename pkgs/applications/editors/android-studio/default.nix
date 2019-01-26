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
    version = "3.4.0.11"; # "Android Studio 3.4 Beta 2"
    build = "183.5240537";
    sha256Hash = "0mv7ayqjkw97jzdifw1cdvjhnzygzkd2a9rc0h99fclhf2nii5yr";
  };
  latestVersion = { # canary & dev
    version = "3.5.0.1"; # "Android Studio 3.5 Canary 2"
    build = "183.5240547";
    sha256Hash = "0z52ig9v2w9i6bqiqpdvgcr6g6sgl8p5317jamg72d5csm9hgfx3";
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
