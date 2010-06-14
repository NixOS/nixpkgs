{ stdenv, fetchurl, qt, zlib, libX11, libXext, libSM, libICE, libXt, glibc
, makeDesktopItem
}:

assert stdenv.isLinux && stdenv.gcc.gcc != null;

stdenv.mkDerivation rec {
  name = "opera-10.10";

  builder = ./builder.sh;
  
  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://mirror.liteserver.nl/pub/opera/linux/1010/final/en/i386/shared/opera-10.10.gcc4-shared-qt3.i386.tar.bz2";
        sha256 = "0y8xahwgx5jw83ky4zkw8ixyfgnd2xg9k0zq15yivhimi60fsppc";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://mirror.liteserver.nl/pub/opera/linux/1010/final/en/x86_64/opera-10.10.gcc4-shared-qt3.x86_64.tar.bz2";
        sha256 = "1z0zgalqv9lnf1jsg3zg9diqfyszh75r7m1dbkifkdawn4zv4q3s";
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
