{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmysofa";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "hoene";
    repo = "libmysofa";
    rev = "v${finalAttrs.version}";
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

  meta = {
    description = "Reader for AES SOFA files to get better HRTFs";
    homepage = "https://github.com/hoene/libmysofa";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
