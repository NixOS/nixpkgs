{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.104";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cargo-expand";
    rev = version;
    hash = "sha256-PSiuTw3H3vl4Tnts5eOTd1v8SLPvYZCkuQ/pTSa3O18=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-apFOBEao2DKsdjdth+vGzzRa9Mw7fTb/88TetY0vp6E=";

  meta = with lib; {
    description = "Cargo subcommand to show result of macro expansion";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${version}";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      figsoda
      xrelkd
    ];
    mainProgram = "cargo-expand";
  };
}
