{ stdenv, cmake, fetchurl, gnumake, makeWrapper, pkgconfig, fetchpatch
, autopanosiftc, boost, cairo, enblend-enfuse, exiv2, fftw, flann, gettext
, glew, ilmbase, lcms2, lensfun, libjpeg, libpng, libtiff, libX11, libXi
, libXmu, libGLU, libGL, openexr, panotools, perlPackages, sqlite, vigra, wxGTK, zlib
}:

stdenv.mkDerivation rec {
  name = "hugin-2019.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/hugin/${name}.tar.bz2";
    sha256 = "1l925qslp98gg7yzmgps10h6dq0nb60wbfk345anlxsv0g2ifizr";
  };

  patches = [
    # Fixes build with exiv2 0.27.1
    (fetchpatch {
      url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/hugin-exiv2-0.27.1.patch?h=packages/hugin";
      sha256 = "1yxvlpvrhyrfd2w6kwx1w3mncsvlzdhp0w7xchy8q6kc2kd5nf7r";
    })
  ];

  buildInputs = [
    boost cairo exiv2 fftw flann gettext glew ilmbase lcms2 lensfun libjpeg
    libpng libtiff libX11 libXi libXmu libGLU libGL openexr panotools sqlite vigra
    wxGTK zlib
  ];

  nativeBuildInputs = [ cmake makeWrapper pkgconfig ];

  # disable installation of the python scripting interface
  cmakeFlags = [ "-DBUILD_HSI:BOOl=OFF" ];

  enableParallelBuilding = true;

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

  meta = with stdenv.lib; {
    homepage = "http://hugin.sourceforge.net/";
    description = "Toolkit for stitching photographs and assembling panoramas, together with an easy to use graphical front end";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ hrdinka ];
    platforms = platforms.linux;
  };
}
