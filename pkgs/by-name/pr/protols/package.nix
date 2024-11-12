{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "protols";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "coder3101";
    repo = "protols";
    rev = "refs/tags/${version}";
    hash = "sha256-2dP3papZsZxvpSfgGTdoRVSZTcOC0iHPBfMmlzB5iJQ=";
  };

  cargoHash = "sha256-94URDioPZXKSSFINTdPBYcES2eGCbhJ46tvcVRWt06o=";

  meta = {
    description = "Protocol Buffers language server written in Rust";
    homepage = "https://github.com/coder3101/protols";
    changelog = "https://github.com/coder3101/protols/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "protols";
  };
}
