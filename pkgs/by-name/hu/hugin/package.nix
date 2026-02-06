{
  lib,
  stdenv,
  cmake,
  fetchurl,
  gnumake,
  makeWrapper,
  pkg-config,
  boost,
  cairo,
  enblend-enfuse,
  exiv2,
  fftw,
  flann,
  gettext,
  glew,
  lcms2,
  lensfun,
  libjpeg,
  libpng,
  libtiff,
  libX11,
  libXi,
  libXmu,
  libGLU,
  libGL,
  openexr,
  panotools,
  perlPackages,
  sqlite,
  vigra,
  wrapGAppsHook3,
  wxGTK32,
  wxGTK' ? wxGTK32,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hugin";
  version = "2025.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/hugin/hugin-${finalAttrs.version}.tar.bz2";
    hash = "sha256-fPjrM6aohIzH+Bb69LyIOJIoiD1VExNtzLXLJDkSq3k=";
  };

  buildInputs = [
    boost
    cairo
    exiv2
    fftw
    flann
    gettext
    glew
    lcms2
    lensfun
    libjpeg
    libpng
    libtiff
    libX11
    libXi
    libXmu
    libGLU
    libGL
    openexr
    panotools
    sqlite
    vigra
    wxGTK'
    zlib
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    wrapGAppsHook3
    wxGTK'
  ];

  strictDeps = true;

  # disable installation of the python scripting interface
  cmakeFlags = [ "-DBUILD_HSI:BOOl=OFF" ];

  # hugin libs are added to NEEDED but not to RUNPATH
  postFixup = ''
    for p in $out/bin/..*; do
      patchelf "$p" --add-rpath $out/lib/hugin
    done
  '';

  postInstall = ''
    for p in $out/bin/*; do
      wrapProgram "$p" \
        --suffix PATH : ${enblend-enfuse}/bin \
        --suffix PATH : ${gnumake}/bin \
        --suffix PATH : ${perlPackages.ImageExifTool}/bin
    done
  '';

  meta = {
    homepage = "https://hugin.sourceforge.io/";
    description = "Toolkit for stitching photographs and assembling panoramas, together with an easy to use graphical front end";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
