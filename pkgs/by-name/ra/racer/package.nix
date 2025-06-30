{
  fetchurl,
  lib,
  stdenv,
  allegro,
  libjpeg,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "racer";
  version = "1.1";

  src =
    if stdenv.hostPlatform.system == "i686-linux" then
      fetchurl {
        url = "http://hippo.nipax.cz/src/racer-${version}.tar.gz";
        sha256 = "0fll1qkqfcjq87k0jzsilcw701z92lfxn2y5ga1n038772lymxl9";
      }
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://hippo.nipax.cz/src/racer-${version}.64.tar.gz";
        sha256 = "0rjy3gmlhwfkb9zs58j0mc0dar0livwpbc19r6zw5r2k6r7xdan0";
      }
    else
      throw "System not supported";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    allegro
    libjpeg
  ];

  prePatch = ''
    sed -i s,/usr/local,$out, Makefile src/HGFX.cpp src/STDH.cpp
    sed -i s,/usr/share,$out/share, src/HGFX.cpp src/STDH.cpp
  '';

  patches = [ ./mkdir.patch ];

  meta = {
    description = "Car racing game";
    mainProgram = "racer";
    homepage = "http://hippo.nipax.cz/download.en.php";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
