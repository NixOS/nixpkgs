{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "protols";
  version = "0.12.5";

  src = fetchFromGitHub {
    owner = "coder3101";
    repo = "protols";
    tag = version;
    hash = "sha256-zs78TKZU35UGAmEXK3EA9B6zRCqeCtNexHVAJERKyX8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Lh6KJ5zclT650tPIpMJBALLj4gnis+fglhewiZ5mpMs=";

  meta = {
    description = "Protocol Buffers language server written in Rust";
    homepage = "https://github.com/coder3101/protols";
    changelog = "https://github.com/coder3101/protols/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "protols";
  };
}
