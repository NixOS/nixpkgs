{ lib, stdenv, fetchFromGitHub, obs-studio, cmake, qtbase, ndi }:

stdenv.mkDerivation rec {
  pname = "obs-ndi";
  version = "4.9.1";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio qtbase ndi ];

  src = fetchFromGitHub {
    owner = "Palakis";
    repo = "obs-ndi";
    rev = version;
    sha256 = "1y3xdqp55jayhg4sinwiwpk194zc4f4jf0abz647x2fprsk9jz7s";
  };

  patches = [ ./fix-search-path.patch ./hardcode-ndi-path.patch ];

  postPatch = ''
    # Add path (variable added in hardcode-ndi-path.patch)
    sed -i -e s,@NDI@,${ndi},g src/obs-ndi.cpp

    # Replace bundled NDI SDK with the upstream version
    # (This fixes soname issues)
    rm -rf lib/ndi
    ln -s ${ndi}/include lib/ndi
  '';

  cmakeFlags = [
    "-DLIBOBS_INCLUDE_DIR=${obs-studio}/include/obs"
    "-DLIBOBS_LIB=${obs-studio}/lib"
    "-DCMAKE_CXX_FLAGS=-I${obs-studio.src}/UI/obs-frontend-api"
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Network A/V plugin for OBS Studio";
    homepage = "https://github.com/Palakis/obs-ndi";
    maintainers = with maintainers; [ jshcmpbll ];
    license = licenses.gpl2;
    platforms = with platforms; linux;
  };
}
