{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "evtx";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "omerbenamram";
    repo = "evtx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RNJIYTSV1czMNAs8Aqu9nDt/mvaC6uLRv9ra8vCShNA=";
  };

  cargoHash = "sha256-kJkMk4bfmijo7IX1XopibFnouahK8sn1SDQtX9ha898=";

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
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "evtx_dump";
  };
})
