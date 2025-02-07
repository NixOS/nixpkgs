{
  lib,
  stdenv,
  fetchurl,
  wxGTK,
  python3,
  zlib,
  libGLU,
  libGL,
  libX11,
  SDL2,
}:
stdenv.mkDerivation rec {
  pname = "golly";
  version = "4.3";

  src = fetchurl {
    hash = "sha256-UdJHgGPn7FDN4rYTgfPBAoYE5FGC43TP8OFBmYIqCB0=";
    url = "mirror://sourceforge/project/golly/golly/golly-${version}/golly-${version}-src.tar.gz";
  };

  buildInputs = [
    wxGTK
    python3
    zlib
    libGLU
    libGL
    libX11
    SDL2
  ];

  nativeBuildInputs = [
    (python3.withPackages (ps: [ ps.setuptools ]))
  ];

  setSourceRoot = ''
    sourceRoot=$(echo */gui-wx)
  '';

  postPatch = ''
    sed -e 's@PYTHON_SHLIB@${python3}/lib/libpython3.so@' -i wxprefs.cpp
    ! grep _SHLIB *.cpp

    grep /lib/libpython wxprefs.cpp
  '';

  makeFlags = [
    "-f"
    "makefile-gtk"
    "ENABLE_SOUND=1"
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
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    downloadPage = "https://sourceforge.net/projects/golly/files/golly";
  };
}
