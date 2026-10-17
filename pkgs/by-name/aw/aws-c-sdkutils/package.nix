{
  lib,
  stdenv,
  fetchFromGitHub,
  aws-c-common,
  cmake,
  nix,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-c-sdkutils";
  # nixpkgs-update: no auto update
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-sdkutils";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SxEt4W5Bxdo+gJiP09FRKzGrqW/wO4NufRgBbWDph/g=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    aws-c-common
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  doCheck = true;

  passthru.tests = {
    inherit nix;
  };

  meta = {
    description = "AWS SDK utility library";
    homepage = "https://github.com/awslabs/aws-c-sdkutils";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ r-burns ];
  };
})
