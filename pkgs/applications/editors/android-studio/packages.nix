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
    version = "3.0.0.5";
    build = "171.4163606";

    src = fetchurl {
      url = "https://dl.google.com/dl/android/studio/ide-zips/${version}/android-studio-ide-${build}-linux.zip";
      sha256 = "1gxnpw4jf3iic9d47sjbndpysq8kk8pgnb8l7azkc2rba5cj8skg";
    };

    meta = stable.meta // {
      homepage = https://developer.android.com/studio/preview/index.html;
    };
  } {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
  };
}
