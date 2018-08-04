{ stdenv, callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.1.3.0"; # "Android Studio 3.1.3"
    build = "173.4819257";
    sha256Hash = "196yaswbxh2nd83gimjxr8ggr5xkdxq7n3xlh6ax73v59pj4hryq";
  };
  betaVersion = {
    version = "3.2.0.22"; # "Android Studio 3.2 Beta 5"
    build = "181.4913314";
    sha256Hash = "016nyn1pqviy089hg0dq7m4cqb39fdxdcy4zknkaq7dmgv1dj6x9";
  };
  latestVersion = { # canary & dev
    version = "3.3.0.3"; # "Android Studio 3.3 Canary 4"
    build = "182.4924367";
    sha256Hash = "03fxjxlsbrpklsss1nvlkb41skr5ymmq9vdns8iikcm1ng925vfd";
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
