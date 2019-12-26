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
    version = "4.0.0.6"; # "Android Studio 4.0 Canary 6"
    build = "193.6052267";
    sha256Hash = "1naxyfnrj7milqha7xbwbcvyi81a7fqb7jsm03hhq5xs2sw55m1c";
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
