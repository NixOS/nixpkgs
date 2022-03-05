{ lib
, stdenv
, cmake
, fetchurl
, gnumake
, makeWrapper
, pkg-config
, fetchpatch
, autopanosiftc
, boost
, cairo
, enblend-enfuse
, exiv2
, fftw
, flann
, gettext
, glew
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
, wxGTK
, zlib
}:

stdenv.mkDerivation rec {
  pname = "hugin";
  version = "2019.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/hugin/hugin-${version}.tar.bz2";
    sha256 = "1l925qslp98gg7yzmgps10h6dq0nb60wbfk345anlxsv0g2ifizr";
  };

  patches = [
    # Fixes build with exiv2 0.27.1
    (fetchpatch {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/0467d8ba362b9c196e4c1dc4be7de0c1b336335b/hugin/trunk/hugin-exiv2-0.27.1.patch";
      sha256 = "1yxvlpvrhyrfd2w6kwx1w3mncsvlzdhp0w7xchy8q6kc2kd5nf7r";
    })
  ];

  buildInputs = [
    boost
    cairo
    exiv2
    fftw
    flann
    gettext
    glew
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

  nativeBuildInputs = [ cmake makeWrapper pkg-config ];

  # disable installation of the python scripting interface
  cmakeFlags = [ "-DBUILD_HSI:BOOl=OFF" ];

  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";

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
