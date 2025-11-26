{
  lib,
  pkgs,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "protols";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "coder3101";
    repo = "protols";
    tag = version;
    hash = "sha256-ZvQC7huJS37cgmAVZoiHZMjFWTdma7dueTczaKDdHks=";
  };

  cargoHash = "sha256-q3GMizdBupQSMVCuRqLjuw0Mof1q3UYOdUBugmrTDMU=";

  FALLBACK_INCLUDE_PATH = "${pkgs.protobuf}/include";

  meta = {
    description = "Protocol Buffers language server written in Rust";
    homepage = "https://github.com/coder3101/protols";
    changelog = "https://github.com/coder3101/protols/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "protols";
  };
}
