{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "evtx";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "omerbenamram";
    repo = "evtx";
    tag = "v${version}";
    hash = "sha256-fgOuhNE77zVjL16oiUifnKZ+X4CQnZuD8tY+h0JTOYU=";
  };

  cargoHash = "sha256-E9BoqpnKhVNwOiEvZROF3xj9Ge8r2CNaBiwHdkdV5aw=";

  postPatch = ''
    # CLI tests will fail in the sandbox
    rm tests/test_cli_interactive.rs
  '';

  meta = {
    description = "Parser for the Windows XML Event Log (EVTX) format";
    homepage = "https://github.com/omerbenamram/evtx";
    changelog = "https://github.com/omerbenamram/evtx/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "evtx_dump";
  };
}
