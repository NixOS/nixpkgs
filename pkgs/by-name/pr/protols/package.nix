{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "protols";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "coder3101";
    repo = "protols";
    tag = version;
    hash = "sha256-v4ROQVoJmrukHFrxykr6EuBFXRuaBnPZ7f36ly7rPhg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fmsPkXwu8qy+SRyP5w940gqNmXg0V/p/vDSI7EIFrh0=";

  meta = {
    description = "Protocol Buffers language server written in Rust";
    homepage = "https://github.com/coder3101/protols";
    changelog = "https://github.com/coder3101/protols/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "protols";
  };
}
