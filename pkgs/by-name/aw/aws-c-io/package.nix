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
  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-io";
    rev = "v${finalAttrs.version}";
    hash = "sha256-z3+7nWXDBrhDrWypZmDBp8EKlFZmy3vGPw0htK85JMQ=";
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

  # Tests require network access.
  doCheck = false;

  passthru.tests = {
    inherit nix;
  };

  meta = {
    description = "AWS SDK for C module for IO and TLS";
    homepage = "https://github.com/awslabs/aws-c-io";
    changelog = "https://github.com/awslabs/aws-c-io/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
