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
  version = "3.26.1";

  src = fetchFromGitHub {
    owner = "chenxiaolong";
    repo = "avbroot";
    tag = "v${version}";
    hash = "sha256-Iu1wbk7UqHw28/NbWkUyGdXnMQMHEBLKqVipPKjoHg0=";
  };

  cargoHash = "sha256-vU601jAGkYC1vhe0Zqr56D7vwNbVErJrDk8ztieZPUs=";

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
