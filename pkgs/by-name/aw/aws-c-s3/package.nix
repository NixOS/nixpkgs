{
  lib,
  stdenv,
  fetchFromGitHub,
  aws-c-auth,
  aws-c-cal,
  aws-c-common,
  aws-c-compression,
  aws-c-http,
  aws-c-io,
  aws-checksums,
  cmake,
  nix,
  s2n-tls,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-c-s3";
  # nixpkgs-update: no auto update
  version = "0.11.5";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-s3";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/0zWzpWiowrFM5/j41QSp2xcTC0xK29+dId8ya/EYG8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    aws-c-auth
    aws-c-cal
    aws-c-common
    aws-c-compression
    aws-c-http
    aws-c-io
    aws-checksums
    s2n-tls
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  # Tests require network access.
  doCheck = false;

  passthru.tests = {
    inherit nix;
  };

  meta = {
    description = "C99 library implementation for communicating with the S3 service";
    homepage = "https://github.com/awslabs/aws-c-s3";
    changelog = "https://github.com/awslabs/aws-c-s3/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ r-burns ];
    mainProgram = "s3";
    platforms = lib.platforms.unix;
  };
})
