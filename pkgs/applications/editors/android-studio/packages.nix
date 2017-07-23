{  stdenv, callPackage, fetchurl, makeFontsConf }:
let
  mkStudio = opts: callPackage (import ./common.nix opts);
in rec {
  stable = mkStudio rec {
    pname = "android-studio";
    version = "2.3.3.0";
    build = "162.4069837";

    src = fetchurl {
      url = "https://dl.google.com/dl/android/studio/ide-zips/${version}/android-studio-ide-${build}-linux.zip";
      sha256 = "0zzis9m2xp44xwkj0zvcqw5rh3iyd3finyi5nqhgira1fkacz0qk";
    };

    meta = with stdenv.lib; {
      description = "The Official IDE for Android";
      homepage = https://developer.android.com/studio/index.html;
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ primeos ];
    };
  } {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
  };

  preview = mkStudio rec {
    pname = "android-studio-preview";
    version = "3.0.0.6";
    build = "171.4182969";

    src = fetchurl {
      url = "https://dl.google.com/dl/android/studio/ide-zips/${version}/android-studio-ide-${build}-linux.zip";
      sha256 = "0s26k5qr0qg6az77yw2mvnhavwi4aza4ifvd45ljank8aqr6sp5i";
    };

    meta = stable.meta // {
      homepage = https://developer.android.com/studio/preview/index.html;
      maintainers = with stdenv.lib.maintainers; [ tomsmeets ];
    };
  } {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
  };
}
