{ lib
, stdenv
, cmake
, fetchurl
, fetchpatch
, gnumake
, makeWrapper
, pkg-config
, autopanosiftc
, boost
, cairo
, enblend-enfuse
, exiv2
, fftw
, flann
, gettext
, glew-egl
, ilmbase
, lcms2
, lensfun
, libjpeg
, libpng
, libtiff
, libX11
, libXi
, libXmu
, libGLU
, libGL
, openexr
, panotools
, perlPackages
, sqlite
, vigra
, wrapGAppsHook
, wxGTK
, zlib
}:

stdenv.mkDerivation rec {
  pname = "hugin";
  version = "2022.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/hugin/hugin-${version}.tar.bz2";
    hash = "sha256-l8hWKgupp0PguVWkPf3gSLHGDNnl8u4rad4agWRuBac=";
  };

  patches = [
    (fetchpatch {
      name = "hugin-2022.0.0-exiv2-0.28.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-gfx/hugin/files/hugin-2022.0.0-exiv2-0.28.patch?id=d18335caa756f5e5c1478d5fe3ba17f011a78c80";
      hash = "sha256-Y+79bFb926GW5oLOL0e5y7kLhqU/vZcry+kLL4H2fUE=";
    })
  ];

  buildInputs = [
    boost
    cairo
    exiv2
    fftw
    flann
    gettext
    glew-egl
    ilmbase
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

  nativeBuildInputs = [ cmake makeWrapper pkg-config wrapGAppsHook ];

  # disable installation of the python scripting interface
  cmakeFlags = [ "-DBUILD_HSI:BOOl=OFF" ];

  env.NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";

  postInstall = ''
    for p in $out/bin/*; do
      wrapProgram "$p" \
        --suffix PATH : ${autopanosiftc}/bin \
        --suffix PATH : ${enblend-enfuse}/bin \
        --suffix PATH : ${gnumake}/bin \
        --suffix PATH : ${perlPackages.ImageExifTool}/bin
    done
  '';

  meta = with lib; {
    homepage = "http://hugin.sourceforge.net/";
    description = "Toolkit for stitching photographs and assembling panoramas, together with an easy to use graphical front end";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ hrdinka ];
    platforms = platforms.linux;
  };
}
