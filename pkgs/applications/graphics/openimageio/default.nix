{ stdenv, fetchFromGitHub, boost, cmake, ilmbase, libjpeg, libpng, libtiff
, opencolorio, openexr, unzip
}:

stdenv.mkDerivation rec {
  pname = "openimageio";
  version = "1.8.16";

  src = fetchFromGitHub {
    owner = "OpenImageIO";
    repo = "oiio";
    rev = "Release-${version}";
    sha256 = "0isx137c6anvs1xfxi0z35v1cw855xvnq2ca0pakqqpdh0yivrps";
  };

  outputs = [ "bin" "out" "dev" "doc" ];

  nativeBuildInputs = [ cmake unzip ];
  buildInputs = [
    boost ilmbase libjpeg libpng
    libtiff opencolorio openexr
  ];

  cmakeFlags = [
    "-DUSE_PYTHON=OFF"
  ];

  makeFlags = [
    "ILMBASE_HOME=${ilmbase.dev}"
    "OPENEXR_HOME=${openexr.dev}"
    "USE_PYTHON=0"
    "INSTALLDIR=${placeholder "out"}"
    "dist_dir="
  ];

  meta = with stdenv.lib; {
    homepage = http://www.openimageio.org;
    description = "A library and tools for reading and writing images";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
    badPlatforms = [ "x86_64-darwin" ];
  };
}
