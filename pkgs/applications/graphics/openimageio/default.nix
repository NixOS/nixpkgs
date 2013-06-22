{ stdenv, fetchurl, boost, cmake, ilmbase, libjpeg, libpng, libtiff
, opencolorio, openexr, unzip
}:

stdenv.mkDerivation rec {
  name = "oiio-${version}";
  version = "1.1.12";

  src = fetchurl {
    url = "https://github.com/OpenImageIO/oiio/archive/Release-${version}.zip";
    sha256 = "196iq15waa2yyryiwhf6ynlpqnpknm4cc4azakg01xs70yiphsfl";
  };

  buildInputs = [ 
    boost cmake ilmbase libjpeg libpng libtiff opencolorio openexr unzip
  ];

  configurePhase = "";

  buildPhase = ''
    make ILMBASE_HOME=${ilmbase} OPENEXR_HOME=${openexr} USE_PYTHON=0 \
      INSTALLDIR=$out dist_dir=
  '';

  installPhase = ":";

  meta = with stdenv.lib; {
    homepage = http://www.openimageio.org;
    description = "A library and tools for reading and writing images";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
