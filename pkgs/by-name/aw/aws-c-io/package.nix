{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  aws-c-cal,
  aws-c-common,
  nix,
  s2n-tls,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-c-io";
  # nixpkgs-update: no auto update
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-io";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gdu1v6ui9y5Y+tp0K0fpbE2e2O4Ky/WPEekphWbhUDQ=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    aws-c-cal
    aws-c-common
    s2n-tls
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  passthru.tests = {
    inherit nix;
  };

  meta = {
    description = "AWS SDK for C module for IO and TLS";
    homepage = "https://github.com/awslabs/aws-c-io";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
