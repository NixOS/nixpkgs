{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  bzip2,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "avbroot";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "chenxiaolong";
    repo = "avbroot";
    rev = "refs/tags/v${version}";
    hash = "sha256-gG8pR/D5oaPPqq0e815J6z+dDVxh4VSoHIm1Yl3x2p4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "bzip2-0.4.4" = "sha256-9YKPFvaGNdGPn2mLsfX8Dh90vR+X4l3YSrsz0u4d+uQ=";
      "zip-0.6.6" = "sha256-oZQOW7xlSsb7Tw8lby4LjmySpWty9glcZfzpPuQSSz0=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [ bzip2 ];

  meta = {
    description = "Sign (and root) Android A/B OTAs with custom keys while preserving Android Verified Boot";
    homepage = "https://github.com/chenxiaolong/avbroot";
    changelog = "https://github.com/chenxiaolong/avbroot/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = "avbroot";
  };
}
