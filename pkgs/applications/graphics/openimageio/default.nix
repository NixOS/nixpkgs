{ stdenv, fetchurl, boost, cmake, ilmbase, libjpeg, libpng, libtiff
, opencolorio, openexr, unzip
}:

stdenv.mkDerivation rec {
  name = "oiio-${version}";
  version = "1.4";

  src = fetchurl {
    url = "https://github.com/OpenImageIO/oiio/archive/RB-${version}.zip";
    sha256 = "0ldj3hwpz363l1zyzf6c62wc5d2cpbiszlpjvv5w6rrsx2ddbbn1";
  };

  buildInputs = [
    boost cmake ilmbase libjpeg libpng libtiff opencolorio openexr unzip
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
