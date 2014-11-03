{ stdenv, fetchurl, boost, cmake, ilmbase, libjpeg, libpng, libtiff
, opencolorio, openexr, unzip
}:

stdenv.mkDerivation rec {
  name = "oiio-${version}";
  version = "1.4.13";

  src = fetchurl {
    url = "https://github.com/OpenImageIO/oiio/archive/Release-${version}.zip";
    sha256 = "1idscm2qqdjgv362l7xk9v162axji7hqh7xdnd3i0wcxwjpgygca";
  };

  buildInputs = [
    boost cmake ilmbase libjpeg libpng libtiff opencolorio openexr
    unzip
  ];

  cmakeFlags = [
    "-DUSE_PYTHON=OFF"
  ];

  buildPhase = ''
    make ILMBASE_HOME=${ilmbase} OPENEXR_HOME=${openexr} USE_PYTHON=0 \
      INSTALLDIR=$out dist_dir=
  '';

  meta = with stdenv.lib; {
    homepage = http://www.openimageio.org;
    description = "A library and tools for reading and writing images";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
