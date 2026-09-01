{
  lib,
  stdenv,
  fetchFromGitHub,
  aws-c-common,
  cmake,
  nix,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-c-compression";
  # nixpkgs-update: no auto update
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-compression";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-gpru+hnppgLHhcPfVBOaMdcT6e8wUjZmY7Caaa/KAW4=";
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

  meta = {
    description = "C99 implementation of huffman encoding/decoding";
    homepage = "https://github.com/awslabs/aws-c-compression";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ r-burns ];
  };
})
