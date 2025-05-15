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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-auth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HzDUINTmgjW7rNEe+5iwZBv6ayxNKmGAJy+Lg4tp1t0=";
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

  propagatedBuildInputs = [ aws-c-sdkutils ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  passthru.tests = {
    inherit nix;
  };

  meta = {
    description = "C99 library implementation of AWS client-side authentication";
    homepage = "https://github.com/awslabs/aws-c-auth";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ r-burns ];
  };
})
