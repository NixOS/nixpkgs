{ callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.5.3.0"; # "Android Studio 3.5.3"
    build = "191.6010548";
    sha256Hash = "1nsm4d3vdx90szqd78a8mjq65xc9m5ipd35cqrlx3c3ny900sqxg";
  };
  betaVersion = {
    version = "3.6.0.18"; # "Android Studio 3.6 RC 1"
    build = "192.6071332";
    sha256Hash = "0xpcihr5xxr9l1kv6aflywshs8fww3s7di0g98mz475whhxwzf3q";
  };
  latestVersion = { # canary & dev
    version = "4.0.0.7"; # "Android Studio 4.0 Canary 7"
    build = "193.6085562";
    sha256Hash = "0vk1vwh2yhsmadkb3v3m042ckzizc41ckqvj3jax8p86gl0b4whj";
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
