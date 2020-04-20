{ callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.6.3.0"; # "Android Studio 3.6.3"
    build = "192.6392135";
    sha256Hash = "0apxmp341m7mbpm2df3qvsbaifwy6yqq746kbhbwlw8bn9hrzv1k";
  };
  betaVersion = {
    version = "4.0.0.13"; # "Android Studio 4.0 Beta 4"
    build = "193.6348893";
    sha256Hash = "0lchi3l50826n1af1z24yclpf27v2q5p1zjbvcmn37wz46d4s4g2";
  };
  latestVersion = { # canary & dev
    version = "4.1.0.6"; # "Android Studio 4.1 Canary 6"
    build = "193.6381907";
    sha256Hash = "0sa5plr96m90wv5hi9bqwa11j6k8k9wa0ji8qmlimdhnpyzhsdrx";
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
