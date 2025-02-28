{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "protols";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "coder3101";
    repo = "protols";
    tag = version;
    hash = "sha256-MsQFGbUWymGYXLABWsDlSXAWBwxw0P9de/txrxdf/Lw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-eO35LukqPFooGFCluLhQacvqlVtreJH/XdnlBYwImbw=";

  meta = {
    description = "Protocol Buffers language server written in Rust";
    homepage = "https://github.com/coder3101/protols";
    changelog = "https://github.com/coder3101/protols/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "protols";
  };
}
