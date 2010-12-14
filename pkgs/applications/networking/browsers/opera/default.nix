{ stdenv, fetchurl, qt, zlib, libX11, libXext, libSM, libICE, libXt, glibc
, makeDesktopItem
}:

assert stdenv.isLinux && stdenv.gcc.gcc != null;

stdenv.mkDerivation rec {
  name = "opera-10.63";

  builder = ./builder.sh;
  
  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://mirror.liteserver.nl/pub/opera/linux/1063/opera-10.63-6450.i386.linux.tar.bz2";
        sha256 = "dd105d602a4b8897749a4cb9610f8bfe2d07d4f4cc9bf3905930c65592737259";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://mirror.liteserver.nl/pub/opera/linux/1063/opera-10.63-6450.x86_64.linux.tar.bz2";
        sha256 = "da8ae14cf317364ab0295102220246b205bf30c59c00cadb571395c90dda7c74";
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
