{ stdenv, cmake, fetchurl, gnumake, pkgconfig
, boost, gettext, tclap, wxGTK
, freeglut, glew, libXi, libXmu, mesa
, autopanosiftc, enblendenfuse, exiv2, ilmbase, lensfun, libpng, libtiff
, openexr, panotools, perlPackages
}:

stdenv.mkDerivation rec {
  name = "hugin-2013.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/hugin/${name}.tar.bz2";
    sha256 = "1mgbvg09xvf0zcm9jfv5lb65nd292l86ffa23yp4pzm6izaiwkj8";
  };

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";

  buildInputs = [ boost gettext tclap wxGTK
                  freeglut glew libXi libXmu mesa
                  exiv2 ilmbase lensfun libtiff libpng openexr panotools
                ];

  # disable installation of the python scripting interface
  cmakeFlags = [ "-DBUILD_HSI:BOOl=OFF" ];

  nativeBuildInputs = [ cmake pkgconfig ];

  enableParallelBuilding = true;

  # commandline tools needed by the hugin batch processor
  # you may have to tell hugin (in the preferences) where these binaries reside
  propagatedUserEnvPackages = [ autopanosiftc enblendenfuse gnumake
                                perlPackages.ImageExifTool
                              ];

  postInstall = ''
    mkdir -p "$out/nix-support"
    echo $propagatedUserEnvPackages > $out/nix-support/propagated-user-env-packages
  '';

  meta = {
    homepage = http://hugin.sourceforge.net/;
    description = "Toolkit for stitching photographs and assembling panoramas, together with an easy to use graphical front end";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
