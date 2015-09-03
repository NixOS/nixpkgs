{ stdenv, fetchurl, boost, cmake, ilmbase, libjpeg, libpng, libtiff
, opencolorio, openexr, unzip
}:

stdenv.mkDerivation rec {
  name = "openimageio-${version}";
  version = "1.4.16";

  src = fetchurl {
    url = "https://github.com/OpenImageIO/oiio/archive/Release-${version}.zip";
    sha256 = "0f9gspsjhniz992c04dm4lvffzz7zjqn1n34nqn6c32r498kimcj";
  };

  buildInputs = [
    boost cmake ilmbase libjpeg libpng libtiff opencolorio openexr
    unzip
  ];

  cmakeFlags = [
    "-DUSE_PYTHON=OFF"
  ];

  preBuild = ''
    makeFlags="ILMBASE_HOME=${ilmbase} OPENEXR_HOME=${openexr} USE_PYTHON=0
      INSTALLDIR=$out dist_dir="
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.openimageio.org;
    description = "A library and tools for reading and writing images";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
