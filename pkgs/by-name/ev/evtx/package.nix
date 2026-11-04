{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "evtx";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "omerbenamram";
    repo = "evtx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DBFt0nvbM8IK4TgveVBq5E38iO1GqtoLnZuP4GvqX9U=";
  };

  cargoHash = "sha256-mOrgicTOwia1gZcz4vvtoIak0tqZAD8zWKoX85FazWU=";

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
