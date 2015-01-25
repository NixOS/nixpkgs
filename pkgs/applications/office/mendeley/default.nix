{ fetchurl, stdenv, dpkg, makeWrapper, which
,gcc, xlibs, qt4, zlib
, ...}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let
  arch32 = "i686-linux";
  arch64 = "x86_64-linux";

  arch = if stdenv.system == arch32
    then "i386"
    else "amd64";

  shortVersion = "1.13.1-stable";

  version = "${shortVersion}_${arch}";

  url = "http://desktop-download.mendeley.com/download/apt/pool/main/m/mendeleydesktop/mendeleydesktop_${version}.deb";
  sha256 = if stdenv.system == arch32
    then "21491da1608daf58da23e7e5eb7619b494b10192acc0f81575daff2a38720f50"
    else "8db101b26dd2978e991421260a2e55d849014f64005930b2528080bbbaa78600";

  deps = [
    gcc.gcc
    qt4
    xlibs.libX11
    zlib
  ];

in

stdenv.mkDerivation {
  name = "mendeley-${version}";

  src = fetchurl {
    url = url;
    sha256 = sha256;
  };

  buildInputs = [ dpkg makeWrapper which ];

  unpackPhase = "true";

  installPhase = ''
    dpkg-deb -x $src $out
    mv $out/opt/mendeleydesktop/{bin,lib,plugins,share} $out

    interpreter=$(patchelf --print-interpreter $(readlink -f $(which patchelf)))
    patchelf --set-interpreter $interpreter $out/bin/mendeleydesktop

    librarypath="${stdenv.lib.makeLibraryPath deps}:$out/lib:$out/lib/qt"
    wrapProgram $out/bin/mendeleydesktop --prefix LD_LIBRARY_PATH : "$librarypath"
  '';

  dontStrip = true;
  dontPatchElf = true;

  meta = {
    homepage = http://www.mendeley.com;
    description = "A reference manager and academic social network";
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
  };

}
