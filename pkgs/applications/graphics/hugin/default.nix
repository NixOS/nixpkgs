{ stdenv, cmake, fetchurl, gnumake, makeWrapper, pkgconfig
, autopanosiftc, boost, cairo, enblend-enfuse, exiv2, fftw, flann, gettext
, glew, ilmbase, lcms2, lensfun, libjpeg, libpng, libtiff, libX11, libXi
, libXmu, libGLU_combined, openexr, panotools, perlPackages, sqlite, vigra, wxGTK, zlib
}:

stdenv.mkDerivation rec {
  name = "hugin-2018.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/hugin/${name}.tar.bz2";
    sha256 = "1jv5wpqbq49fhbl5g521g1qxhdm1rm7acxd18fr3n3n5d830vbyk";
  };

  buildInputs = [
    boost cairo exiv2 fftw flann gettext glew ilmbase lcms2 lensfun libjpeg
    libpng libtiff libX11 libXi libXmu libGLU_combined openexr panotools sqlite vigra
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
    homepage = http://hugin.sourceforge.net/;
    description = "Toolkit for stitching photographs and assembling panoramas, together with an easy to use graphical front end";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric hrdinka ];
    platforms = platforms.linux;
  };
}
