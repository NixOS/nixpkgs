{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "evtx";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "omerbenamram";
    repo = "evtx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v57lo1ggElGJD618ojuADspmhlZAMgmzD5DxEdtp2Ak=";
  };

  cargoHash = "sha256-qjlN10YS79S0JV2MPFB9SxPDUQnoVdqVf8kYpLt4w9g=";

  postPatch = ''
    # CLI tests will fail in the sandbox
    rm tests/test_cli_interactive.rs
  '';

  meta = {
    description = "Parser for the Windows XML Event Log (EVTX) format";
    homepage = "https://github.com/omerbenamram/evtx";
    changelog = "https://github.com/omerbenamram/evtx/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "evtx_dump";
  };
})
