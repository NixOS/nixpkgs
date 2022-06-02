{lib, stdenv, fetchurl, wxGTK, perl, python3, zlib, libGLU, libGL, libX11, SDL2}:
stdenv.mkDerivation rec {
  pname = "golly";
  version = "4.1";

  src = fetchurl {
    sha256 = "1j30dpzy6wh8fv1j2750hzc6wb0nhk83knl9fapccxgxw9n5lrbc";
    url="mirror://sourceforge/project/golly/golly/golly-${version}/golly-${version}-src.tar.gz";
  };

  buildInputs = [
    wxGTK perl python3 zlib libGLU libGL libX11 SDL2
  ];

  setSourceRoot = ''
    sourceRoot=$(echo */gui-wx/)
  '';

  postPatch = ''
    sed -e '/gollydir =/agollydir += "/../share/golly/";' -i wxgolly.cpp
    grep share/golly wxgolly.cpp

    sed -e 's@PYTHON_SHLIB@${python3}/lib/libpython3.so@' -i wxprefs.cpp
    sed -e 's@PERL_SHLIB@'"$(find "${perl}/lib/" -name libperl.so)"'@' -i wxprefs.cpp
    ! grep _SHLIB *.cpp

    grep /lib/libpython wxprefs.cpp
    grep /libperl wxprefs.cpp
  '';

  makeFlags=[
    "-f" "makefile-gtk"
    "ENABLE_SOUND=1" "ENABLE_PERL=1"
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
