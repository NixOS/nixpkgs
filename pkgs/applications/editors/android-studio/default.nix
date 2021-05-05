{ callPackage, makeFontsConf, gnome2, buildFHSUserEnv }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
    inherit buildFHSUserEnv;
  };
  stableVersion = {
    version = "4.2.1.0"; # "Android Studio 4.2.1"
    build = "202.7351085";
    sha256Hash = "074y6i0h8zamjgvvs882im44clds3g6aq8rssl7sq1wx6hrn5q36";
  };
  betaVersion = {
    version = "4.2.0.24"; # "Android Studio 4.2.0"
    build = "202.7322048";
    sha256Hash = "1ii1zf8mv7xyql56wwkcdj5l4g3zaprdszv6r9md9r5zh78k4ccz";
  };
  latestVersion = { # canary & dev
    version = "2020.3.1.10"; # "Android Studio Arctic Fox (2020.3.1) Canary 10"
    sha256Hash = "15xxyjjjy5pnimc66dcwnqb7z4lq7ll4fl401a3br5ca4d1hpgsj";
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
