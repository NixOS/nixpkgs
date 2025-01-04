{
  lib,
  stdenv,
  fetchFromGitHub,
  aws-c-cal,
  aws-c-common,
  aws-c-compression,
  aws-c-io,
  cmake,
  nix,
  s2n-tls,
}:

stdenv.mkDerivation rec {
  pname = "aws-c-http";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-http";
    rev = "v${version}";
    hash = "sha256-86auAZGoaYIpoTVlB9uC+nKMNt1QRNor+/68B5D36r8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    aws-c-cal
    aws-c-common
    aws-c-compression
    aws-c-io
    s2n-tls
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  passthru.tests = {
    inherit nix;
  };

  meta = with lib; {
    description = "C99 implementation of the HTTP/1.1 and HTTP/2 specifications";
    homepage = "https://github.com/awslabs/aws-c-http";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ r-burns ];
  };
}
