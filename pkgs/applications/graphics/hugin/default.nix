{ stdenv, cmake, fetchurl, gnumake, pkgconfig, makeWrapper
, boost, gettext, tclap, wxGTK
, freeglut, glew, libX11, libXi, libXmu, mesa, cairo
, autopanosiftc, enblend-enfuse, exiv2, fftw, ilmbase, lensfun, libpng, libtiff
, openexr, panotools, perlPackages, sqlite, vigra
}:

stdenv.mkDerivation rec {
  name = "hugin-2015.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/hugin/${name}.tar.bz2";
    sha256 = "1gfblax9rxay8xskz5r8bips4nfh70vkyrb8ksgl6pg91c8krn9c";
  };

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";

  buildInputs = [ boost gettext tclap wxGTK
                  freeglut glew libX11 libXi libXmu mesa cairo
                  exiv2 fftw ilmbase lensfun libtiff libpng openexr panotools
                  sqlite vigra
                  perlPackages.ImageExifTool makeWrapper
                ];

  # disable installation of the python scripting interface
  cmakeFlags = [ "-DBUILD_HSI:BOOl=OFF" ];

  nativeBuildInputs = [ cmake pkgconfig ];

  enableParallelBuilding = true;

  postInstall = ''
    for p in $out/bin/*; do
      wrapProgram "$p" \
        --suffix PATH : ${autopanosiftc}/bin \
        --suffix PATH : ${enblend-enfuse}/bin \
        --suffix PATH : ${gnumake}/bin \
        --suffix PATH : ${perlPackages.ImageExifTool}/bin
    done
  '';

  meta = {
    homepage = http://hugin.sourceforge.net/;
    description = "Toolkit for stitching photographs and assembling panoramas, together with an easy to use graphical front end";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ viric hrdinka ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
