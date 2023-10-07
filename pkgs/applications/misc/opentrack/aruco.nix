{ lib, stdenv, cmake, fetchFromGitHub, opencv4 }:

stdenv.mkDerivation {
  pname = "opentrack-aruco";
  version = "unstable-20190303";

  src = fetchFromGitHub {
    owner = "opentrack";
    repo = "aruco";
    rev = "12dc60efd61149227bd05c805208d9bcce308f6d";
    sha256 = "0gkrixgfbpg8pls4qqilphbz4935mg5z4p18a0vv6kclmfccw9ad";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ opencv4 ];

  env.NIX_CFLAGS_COMPILE = "-Wall -Wextra -Wpedantic -ffast-math -O3";

  preInstall = ''
    mkdir -p $out/include/aruco
  '';

  # copy headers required by main package
  postInstall = ''
    cp $src/src/*.h $out/include/aruco
  '';

  meta = with lib; {
    homepage = "https://github.com/opentrack/aruco";
    description = "C++ library for detection of AR markers based on OpenCV";
    license = licenses.isc;
    maintainers = with maintainers; [ zaninime ];
  };
}
