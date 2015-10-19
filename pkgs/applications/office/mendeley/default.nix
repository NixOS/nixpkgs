{ fetchurl, stdenv, dpkg, makeWrapper, which
,gcc, xorg, qt4, zlib
, ...}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let
  arch32 = "i686-linux";
  arch64 = "x86_64-linux";

  arch = if stdenv.system == arch32
    then "i386"
    else "amd64";

  shortVersion = "1.15-stable";

  version = "${shortVersion}_${arch}";

  url = "http://desktop-download.mendeley.com/download/apt/pool/main/m/mendeleydesktop/mendeleydesktop_${version}.deb";
  sha256 = if stdenv.system == arch32
    then "16274a1ad981f8abd6facae88e8412eaf5c8b9b238ff4e07fa7c7b5f498c3cc7"
    else "a455f0cf898f1df66dd5a38c656718a9f8b0f6e80ee7205b37635a8261f9d3cf";

  deps = [
    gcc.cc
    qt4
    xorg.libX11
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
