{
  lib,
  stdenv,
  fetchFromGitHub,
  aws-c-common,
  cmake,
  nix,
}:

stdenv.mkDerivation rec {
  pname = "aws-c-compression";
  # nixpkgs-update: no auto update
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-compression";
    rev = "v${version}";
    sha256 = "sha256-EjvOf2UMju6pycPdYckVxqQ34VOhrIIyvK+O3AVRED4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    aws-c-common
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  passthru.tests = {
    inherit nix;
  };

  meta = with lib; {
    description = "C99 implementation of huffman encoding/decoding";
    homepage = "https://github.com/awslabs/aws-c-compression";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ r-burns ];
  };
}
