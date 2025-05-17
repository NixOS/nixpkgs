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
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-http";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gZhZe988AAMk8L7j1100xFhUCtbmBj62Kdb7p5fSyio=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    aws-c-cal
    aws-c-common
    aws-c-compression
    aws-c-io
    s2n-tls
  ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  passthru.tests = {
    inherit nix;
  };

  meta = {
    description = "C99 implementation of the HTTP/1.1 and HTTP/2 specifications";
    homepage = "https://github.com/awslabs/aws-c-http";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ r-burns ];
  };
})
