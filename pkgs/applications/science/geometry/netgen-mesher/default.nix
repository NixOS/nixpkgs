{ stdenv, opencascade, fetchFromGitHub, cmake, python3, tcl, tk, libjpeg, zlib, mesa, libGLU, xorg, ffmpeg }:


stdenv.mkDerivation rec {
  pname = "netgen-mesher";

  version = "6.2.2004";

  src = fetchFromGitHub {
    owner = "NGSolve";
    repo = "netgen";
    rev = "v${version}";
    # pybind11 is a submodule
    fetchSubmodules = true;
    sha256 = "05s982z1s3rny20cafwbrr7n1z0ql7czq97zs75hgqwrbldfij5y";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ python3 tcl tk libjpeg ffmpeg zlib mesa libGLU xorg.libXmu opencascade ];

  cmakeFlags = [
    "-DUSE_JPEG=ON"
    "-DUSE_MPEG=ON"
    "-DUSE_OCC=ON"
    "-DOCC_INCLUDE_DIR=${opencascade}/include/oce"
  ];

  meta = {
    description = "An automatic 3d tetrahedral mesh generator";
    homepage = "https://sourceforge.net/projects/netgen-mesher/";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
  };
}
