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
    version = "3.4.0.14"; # "Android Studio 3.4 Beta 5"
    build = "183.5310756";
    sha256Hash = "0np8600qvqpw9kcmgp04i1nak1339ck1iidkzr75kigp5rgdl2bq";
  };
  latestVersion = { # canary & dev
    version = "3.5.0.4"; # "Android Studio 3.5 Canary 5"
    build = "183.5320907";
    sha256Hash = "1i56r58kcwrllx3a85dhsz9m0amb7xj9ybqfkdf1a8ipv1hdqs1g";
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
