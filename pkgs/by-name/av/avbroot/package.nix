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
  version = "3.15.0";

  src = fetchFromGitHub {
    owner = "chenxiaolong";
    repo = "avbroot";
    tag = "v${version}";
    hash = "sha256-OICx08MiiiocqVB61fMiUSmG7QOpsrLfPkLuDktTXt0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-iZUGFzg+x4aPL8AoPYVugjrB5ZSrmaCRWMcEovlcPx4=";

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
