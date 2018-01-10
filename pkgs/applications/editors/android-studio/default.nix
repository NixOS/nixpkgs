{ stdenv, callPackage, fetchurl, makeFontsConf }:
let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
  };
in rec {
  stable = mkStudio {
    pname = "android-studio";
    version = "3.0.1.0"; # "Android Studio 3.0.1"
    build = "171.4443003";
    sha256Hash = "1krahlqr70nq3csqiinq2m4fgs68j11hd9gg2dx2nrpw5zni0wdd";

    meta = with stdenv.lib; {
      description = "The Official IDE for Android (stable version)";
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

  preview = mkStudio {
    pname = "android-studio-preview";
    version = "3.1.0.6"; # "Android Studio 3.1 Canary 7"
    build = "173.4524538";
    sha256Hash = "0rj7swychriznylrr09g0rnj12rymms925xbry85ba72hj1jjf6w";

    meta = stable.meta // {
      description = "The Official IDE for Android (preview version)";
      homepage = https://developer.android.com/studio/preview/index.html;
    };
  };
}
