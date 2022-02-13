{ lib, stdenv, fetchFromGitHub, boost, cmake, ilmbase, libjpeg, libpng, libtiff
, opencolorio_1, openexr, unzip
}:

stdenv.mkDerivation rec {
  pname = "openimageio";
  version = "1.8.17";

  src = fetchFromGitHub {
    owner = "OpenImageIO";
    repo = "oiio";
    rev = "Release-${version}";
    sha256 = "0zq34szprgkrrayg5sl3whrsx2l6lr8nw4hdrnwv2qhn70jbi2w2";
  };

  outputs = [ "bin" "out" "dev" "doc" ];

  nativeBuildInputs = [ cmake unzip ];
  buildInputs = [
    boost ilmbase libjpeg libpng
    libtiff opencolorio_1 openexr
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

  patches = [
    # Backported from https://github.com/OpenImageIO/oiio/pull/2539 for 1.8.17
    ./2539_backport.patch
  ];

  meta = with lib; {
    homepage = "http://www.openimageio.org";
    description = "A library and tools for reading and writing images";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
