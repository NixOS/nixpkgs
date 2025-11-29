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
  wxGTK,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "hugin";
  version = "2025.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/hugin/hugin-${version}.tar.bz2";
    hash = "sha256-DeJ6XVQy421OXTisJde8r8e33VQqqwMWQKYe1mdnB2w=";
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
    wxGTK
    zlib
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    wrapGAppsHook3
    wxGTK
  ];

  strictDeps = true;

  # disable installation of the python scripting interface
  cmakeFlags = [ "-DBUILD_HSI:BOOl=OFF" ];

  postInstall = ''
    for p in $out/bin/*; do
      wrapProgram "$p" \
        --suffix PATH : ${enblend-enfuse}/bin \
        --suffix PATH : ${gnumake}/bin \
        --suffix PATH : ${perlPackages.ImageExifTool}/bin
    done
  '';

  meta = with lib; {
    homepage = "https://hugin.sourceforge.io/";
    description = "Toolkit for stitching photographs and assembling panoramas, together with an easy to use graphical front end";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ hrdinka ];
    platforms = platforms.linux;
  };
}
