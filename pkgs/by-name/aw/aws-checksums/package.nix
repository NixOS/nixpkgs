{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  aws-c-common,
  nix,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-checksums";
  # nixpkgs-update: no auto update
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-checksums";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-oXH2okNrWm19i0zfE9w5/kCkzkd8RPXZk5P5Q8HCnRM=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ aws-c-common ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  doCheck = true;

  passthru.tests = {
    inherit nix;
  };

  meta = {
    description = "HW accelerated CRC32c and CRC32";
    homepage = "https://github.com/awslabs/aws-checksums";
    changelog = "https://github.com/awslabs/aws-checksums/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
