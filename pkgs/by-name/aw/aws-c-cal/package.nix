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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-cal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5it5z759jCODr2JgHg9b8+ILPA0cJYkiuQY6jC5bSxo=";
  };

  patches = [
    # Fix openssl adaptor code for musl based static binaries.
    ./aws-c-cal-musl-compat.patch
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    aws-c-common
    openssl
  ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  passthru.tests = {
    inherit nix;
  };

  meta = {
    description = "AWS Crypto Abstraction Layer";
    homepage = "https://github.com/awslabs/aws-c-cal";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ orivej ];
  };
})
