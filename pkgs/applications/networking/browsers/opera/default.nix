{ stdenv, fetchurl, qt, zlib, libX11, libXext, libSM, libICE, libstdcpp5, glibc
, motif ? null, libXt ? null
, makeDesktopItem
}:

assert motif != null -> libXt != null;

# !!! Add Xinerama and Xrandr dependencies?  Or should those be in Qt?

# Hm, does Opera 9.x still use Motif for anything?

stdenv.mkDerivation rec {
  version = "10.0";
  name = "opera-${version}";

  inherit libstdcpp5;

  builder = ./builder.sh;
    src = if (stdenv.system == "i686-linux") then
      fetchurl {
	url = http://mirror.liteserver.nl/pub/opera/linux/1000/final/en/i386/shared/opera-10.00.gcc4-shared-qt3.i386.tar.gz ;
        sha256 = "1l87rxdzq2mb92jbwj4gg79j177yzyfbkqb52gcdwicw8jcmhsad";
      } else if (stdenv.system == "x86_64-linux") then
      fetchurl {
        url = http://mirror.liteserver.nl/pub/opera/linux/1000/final/en/x86_64/opera-10.00.gcc4-shared-qt3.x86_64.tar.gz ;
        sha256 = "0w9a56j3jz0bjdj98k6n4xmrjnkvlxm32cfvh2c0f5pvgwcr642i";
      } else throw "unsupported platform ${stdenv.system} (only i686-linux and x86_64 linux supported yet)";

  dontStrip = 1;
  # operapluginwrapper seems to require libXt ?
  # Adding it makes startup faster and omits error messages (on x68)
  libPath =
    [glibc qt motif zlib libX11 libXt libXext libSM libICE libstdcpp5]
    ++ (if motif != null then [motif ] else []);

  desktopItem = makeDesktopItem {
    name = "Opera";
    exec = "opera";
    icon = "opera";
    comment = "Opera Web Browser";
    desktopName = "Opera";
    genericName = "Web Browser";
    categories = "Application;Network;";
  };


  meta = {
    homepage = http://www.opera.com;
  };
}
