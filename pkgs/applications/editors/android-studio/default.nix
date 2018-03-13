{ stdenv, callPackage, fetchurl, makeFontsConf, gnome2 }:
let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
in rec {
  # Old alias
  preview = beta;

  # Attributes are named by the channels

  # linux-bundle
  stable = mkStudio {
    pname = "android-studio";
    #pname = "android-studio-stable"; # TODO: Rename
    version = "3.0.1.0"; # "Android Studio 3.0.1"
    build = "171.4443003";
    sha256Hash = "1krahlqr70nq3csqiinq2m4fgs68j11hd9gg2dx2nrpw5zni0wdd";

    meta = with stdenv.lib; {
      description = "The Official IDE for Android (stable channel)";
      longDescription = ''
        Android Studio is the official IDE for Android app development, based on
        IntelliJ IDEA.
      '';
      homepage = https://developer.android.com/studio/index.html;
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ primeos ];
    };
  };

  # linux-beta-bundle
  beta = mkStudio {
    pname = "android-studio-preview";
    #pname = "android-studio-beta"; # TODO: Rename
    version = "3.1.0.14"; # "Android Studio 3.1 RC 2"
    build = "173.4640767";
    sha256Hash = "00v8qbis4jm31v1g9989f9y15av6p3ywj8mmfxcsc3hjlpzdgid8";

    meta = stable.meta // {
      description = "The Official IDE for Android (beta channel)";
      homepage = https://developer.android.com/studio/preview/index.html;
    };
  };

  dev = mkStudio {
    pname = "android-studio-dev";
    version = "3.2.0.5"; # "Android Studio 3.2 Canary 6"
    build = "173.4640885";
    sha256Hash = "1fbjk1dhvi975dm09s9iz9ja53fjqca07nw5h068gdj3358pj3k8";

    meta = beta.meta // {
      description = "The Official IDE for Android (dev channel)";
    };
  };

  canary = mkStudio {
    pname = "android-studio-canary";
    version = "3.2.0.5"; # "Android Studio 3.2 Canary 6"
    build = "173.4640885";
    sha256Hash = "1fbjk1dhvi975dm09s9iz9ja53fjqca07nw5h068gdj3358pj3k8";

    meta = beta.meta // {
      description = "The Official IDE for Android (canary channel)";
    };
  };
}
