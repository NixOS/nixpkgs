{lib, stdenv, fetchurl, wxGTK, perl, python3, zlib, libGLU, libGL, libX11, SDL2}:
stdenv.mkDerivation rec {
  pname = "golly";
  version = "4.2";

  src = fetchurl {
    hash = "sha256-VpEoqSPaZMP/AGIYZAbk5R/f8Crqvx8pKYN1O9Bl6V0=";
    url="mirror://sourceforge/project/golly/golly/golly-${version}/golly-${version}-src.tar.gz";
  };

  buildInputs = [
    wxGTK perl python3 zlib libGLU libGL libX11 SDL2
  ];

  setSourceRoot = ''
    sourceRoot=$(echo */gui-wx)
  '';

  postPatch = ''
    sed -e 's@PYTHON_SHLIB@${python3}/lib/libpython3.so@' -i wxprefs.cpp
    sed -e 's@PERL_SHLIB@'"$(find "${perl}/lib/" -name libperl.so)"'@' -i wxprefs.cpp
    ! grep _SHLIB *.cpp

    grep /lib/libpython wxprefs.cpp
    grep /libperl wxprefs.cpp
  '';

  makeFlags=[
    "-f" "makefile-gtk"
    "ENABLE_SOUND=1" "ENABLE_PERL=1"
    "GOLLYDIR=${placeholder "out"}/share/golly"
  ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp ../golly ../bgolly "$out/bin"

    mkdir -p "$out/share/doc/golly/"
    cp ../docs/*  "$out/share/doc/golly/"

    mkdir -p "$out/share/golly"
    cp -r ../{Help,Patterns,Scripts,Rules} "$out/share/golly"
  '';

  meta = {
    description = "Cellular automata simulation program";
    license = lib.licenses.gpl2;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
    downloadPage = "https://sourceforge.net/projects/golly/files/golly";
  };
}
