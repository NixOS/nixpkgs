{ stdenv, fetchurl, qt, zlib, libX11, libXext, libSM, libICE, libXt, glibc
, makeDesktopItem
}:

assert stdenv.isLinux && stdenv.gcc.gcc != null;

stdenv.mkDerivation rec {
  name = "opera-10.00";

  builder = ./builder.sh;
  
  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://mirror.liteserver.nl/pub/opera/linux/1000/final/en/i386/shared/${name}.gcc4-shared-qt3.i386.tar.gz";
        sha256 = "1l87rxdzq2mb92jbwj4gg79j177yzyfbkqb52gcdwicw8jcmhsad";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://mirror.liteserver.nl/pub/opera/linux/1000/final/en/x86_64/${name}.gcc4-shared-qt3.x86_64.tar.gz";
        sha256 = "0w9a56j3jz0bjdj98k6n4xmrjnkvlxm32cfvh2c0f5pvgwcr642i";
      }
    else throw "Opera is not supported on ${stdenv.system} (only i686-linux and x86_64 linux are supported)";

  dontStrip = 1;
  
  # `operapluginwrapper' requires libXt. Adding it makes startup faster
  # and omits error messages (on x86).
  libPath =
    let list = [ stdenv.gcc.gcc glibc qt zlib libX11 libXt libXext libSM libICE];
    in stdenv.lib.makeLibraryPath list
        + ":" + (if stdenv.system == "x86_64-linux" then stdenv.lib.makeSearchPath "lib64" list else "");

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
    description = "The Opera web browser";
  };
}
