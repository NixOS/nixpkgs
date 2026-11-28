{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "evtx";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "omerbenamram";
    repo = "evtx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wxymL5X68WtXnrb9h+FcMFx0hfaVKtIrjsejv/y/k2k=";
  };

  cargoHash = "sha256-PkZ07UwtZRTPHvWSfeuDj0iuu7eU3aIeYgxg4NWtp2I=";

  postPatch = ''
    # CLI tests will fail in the sandbox
    rm tests/test_cli_interactive.rs
  '';

  checkFlags = [
    "--skip=wevt_templates_research::wevt_dll_adtschema"
    "--skip=wevt_templates_research::wevt_dll_lsasrv"
    "--skip=wevt_templates_research::wevt_dll_services"
    "--skip=wevt_templates_research::wevt_dll_wevtsvc"
  ];

  meta = {
    description = "Parser for the Windows XML Event Log (EVTX) format";
    homepage = "https://github.com/omerbenamram/evtx";
    changelog = "https://github.com/omerbenamram/evtx/blob/v${finalAttrs.version}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "evtx_dump";
  };
})
