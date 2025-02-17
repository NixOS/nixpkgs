{ lib
, stdenv
, fetchFromGitHub
, cmake
, doxygen
, graphviz
, makeWrapper
, boost
, SDL2
, python3
, freetype
, openal
, libogg
, libvorbis
, zlib
, libpng
, libtiff
, libjpeg
, libGLU
, libGL
, glew
, libxslt
}:

stdenv.mkDerivation rec {
  pname = "freeorion";
  version = "0.5.0.1-unstable-2024-07-28";

  src = fetchFromGitHub {
    owner = "freeorion";
    repo = "freeorion";
    # Current `release-0.5` commit to pick up Boost and GCC 14 fixes
    # until another release is cut.
    rev = "dc3d6a4f01aa78229c419fa17b4e383f73b024e2";
    hash = "sha256-9yPk77YeYkGMJqrlDYRTUMDKMWpxUXhVCnHhomiUc/A=";
  };

  buildInputs = [
    (boost.override { enablePython = true; python = python3; })
    (python3.withPackages (p: with p; [ pycodestyle ]))
    SDL2
    freetype
    glew
    libGL
    libGLU
    libjpeg
    libogg
    libpng
    libtiff
    libvorbis
    openal
    zlib
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    makeWrapper
  ];

  # as of 0.5.0.1 FreeOrion doesn't work with "-DOpenGL_GL_PREFERENCE=GLVND"
  cmakeFlags = [ "-DOpenGL_GL_PREFERENCE=LEGACY" ];

  postInstall = ''
    mkdir -p $out/libexec
    # We need final slashes for XSLT replace to work properly
    substitute ${./fix-paths.xslt} $out/share/freeorion/fix-paths.xslt \
      --subst-var-by nixStore "$NIX_STORE/" \
      --subst-var-by out "$out/"
    substitute ${./fix-paths.sh} $out/libexec/fix-paths \
      --subst-var-by libxsltBin ${libxslt.bin} \
      --subst-var-by shell ${stdenv.shell} \
      --subst-var out
    chmod +x $out/libexec/fix-paths

    wrapProgram $out/bin/freeorion \
      --run $out/libexec/fix-paths \
      --prefix LD_LIBRARY_PATH : $out/lib/freeorion
  '';

  meta = with lib; {
    description = "Free, open source, turn-based space empire and galactic conquest (4X) computer game";
    homepage = "https://www.freeorion.org/";
    license = with licenses; [ gpl2Only cc-by-sa-30 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ tex ];
  };
}
