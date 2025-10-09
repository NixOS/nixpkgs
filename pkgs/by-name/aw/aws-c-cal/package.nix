{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  aws-c-common,
  nix,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-c-cal";
  # nixpkgs-update: no auto update
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-cal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ufMoB71xebxO/Cu/xVQ3BMrcCgIlkG+MXH2Ru2i6uXo=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    aws-c-common
    openssl
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  passthru.tests = {
    inherit nix;
  };

  meta = with lib; {
    description = "AWS Crypto Abstraction Layer";
    homepage = "https://github.com/awslabs/aws-c-cal";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
})
