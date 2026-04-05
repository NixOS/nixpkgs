{
  lib,
  stdenv,
  fetchFromGitHub,
  aws-c-cal,
  aws-c-common,
  aws-c-compression,
  aws-c-http,
  aws-c-io,
  aws-c-sdkutils,
  cmake,
  nix,
  s2n-tls,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-c-auth";
  # nixpkgs-update: no auto update
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-auth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yp+b4Fc1/oit4Qx9/+XvMg2Hwk1quCK0AhXU0AiYacg=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    aws-c-cal
    aws-c-common
    aws-c-compression
    aws-c-http
    aws-c-io
    s2n-tls
  ];

  propagatedBuildInputs = [
    aws-c-sdkutils
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
    description = "C99 library implementation of AWS client-side authentication";
    homepage = "https://github.com/awslabs/aws-c-auth";
    changelog = "https://github.com/awslabs/aws-c-auth/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ r-burns ];
  };
})
