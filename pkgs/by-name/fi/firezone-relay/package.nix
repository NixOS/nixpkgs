{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "firezone-relay";
  version = "0-unstable-2025-02-10";
  src = fetchFromGitHub {
    owner = "firezone";
    repo = "firezone";
    rev = "7ea17c144a98780600cd8c40c4d5b6b344f9d917";
    hash = "sha256-UO7sWuInpH+yU1jq0EnciDTAKLPndPiR9iKFZjSWsO4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cl402fouhx5uK7Z8jxf6KP1fP6nvDEWnWF+jk/5l4ro=";
  sourceRoot = "${src.name}/rust";
  buildAndTestSubdir = "relay";
  RUSTFLAGS = "--cfg system_certs";

  # Required to remove profiling arguments which conflict with this builder
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = {
    description = "STUN/TURN server for the Firezone zero-trust access platform";
    homepage = "https://github.com/firezone/firezone";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      oddlama
      patrickdag
    ];
    mainProgram = "firezone-relay";
  };
}
