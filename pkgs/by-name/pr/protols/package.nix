{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "protols";
  version = "0.11.5";

  src = fetchFromGitHub {
    owner = "coder3101";
    repo = "protols";
    tag = version;
    hash = "sha256-SW7Ef4HRuv1z2QwHqj+S9MO9t4Pi+uDRYFPxb82y4Nc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bl9N6Kv01QSZAr7BXLNJ2owcwtxP+vhTXUWLAud2npA=";

  meta = {
    description = "Protocol Buffers language server written in Rust";
    homepage = "https://github.com/coder3101/protols";
    changelog = "https://github.com/coder3101/protols/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "protols";
  };
}
