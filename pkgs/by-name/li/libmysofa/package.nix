{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "libmysofa";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "hoene";
    repo = "libmysofa";
    rev = "v${version}";
    hash = "sha256-jvib1hGPJEY2w/KjlD7iTtRy1s8LFG+Qhb2d6xdpUyc=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
    "-DCODE_COVERAGE=OFF"
  ];

  meta = with lib; {
    description = "Reader for AES SOFA files to get better HRTFs";
    homepage = "https://github.com/hoene/libmysofa";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
