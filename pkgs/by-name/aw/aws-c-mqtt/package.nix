{
  lib,
  stdenv,
  fetchFromGitHub,
  aws-c-cal,
  aws-c-common,
  aws-c-compression,
  aws-c-http,
  aws-c-io,
  cmake,
  nix,
  s2n-tls,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-c-mqtt";
  # nixpkgs-update: no auto update
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-mqtt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5oNZ2t5+vTf3boAIvaC1q9pGeiOzAOqXziTdwg1nBK8=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    aws-c-cal
    aws-c-common
    aws-c-compression
    aws-c-http
    aws-c-io
    s2n-tls
  ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  passthru.tests = {
    inherit nix;
  };

  meta = {
    description = "C99 implementation of the MQTT 3.1.1 specification";
    homepage = "https://github.com/awslabs/aws-c-mqtt";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ r-burns ];
  };
})
