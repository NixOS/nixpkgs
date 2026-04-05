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

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-c-http";
  # nixpkgs-update: no auto update
  version = "0.10.11";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-http";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wkVhO4iLt9BEZSPW1NuGFDZWPOT4GPqemCG3p17gklM=";
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

  env.NIX_CFLAGS_COMPILE = toString [
    # http.c:571:12: error: implicit declaration of function 'aws_io_error_code_is_retryable' [-Wimplicit-function-declaration]
    "-Wno-error=implicit-function-declaration"
  ];

  # Tests require network access.
  doCheck = false;

  passthru.tests = {
    inherit nix;
  };

  meta = {
    description = "C99 implementation of the HTTP/1.1 and HTTP/2 specifications";
    homepage = "https://github.com/awslabs/aws-c-http";
    changelog = "https://github.com/awslabs/aws-c-http/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ r-burns ];
  };
})
