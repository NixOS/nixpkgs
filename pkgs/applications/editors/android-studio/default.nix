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
    version = "3.0.0.18"; # "Android Studio 3.0"
    build = "171.4408382";
    sha256Hash = "18npm7ckdybj6vc2vndr0wd50da19m9z2j7wld2mdidnl5ggk4br";

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
    version = "3.1.0.4"; # "Android Studio 3.1 Canary 5"
    build = "171.4474551";
    sha256Hash = "0rgz1p67ra4q0jjb343xqm7c3yrpk1mly8r80cvpqqqq4xgfwa20";

    meta = stable.meta // {
      description = "The Official IDE for Android (preview version)";
      homepage = https://developer.android.com/studio/preview/index.html;
    };
  };
}
