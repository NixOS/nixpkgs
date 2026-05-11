{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chainsaw";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "WithSecureLabs";
    repo = "chainsaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ywHPDVHpw0TrzeWPzZ3cvQSxCr2Di2YjS0Not1B9vlg=";
  };

  cargoHash = "sha256-AA8JQiGukh4SRZyciuE2u4OUo7HNeb6+SWej9vlw5z8=";

  ldflags = [
    "-w"
    "-s"
  ];

  checkFlags = [
    # failed
    "--skip=analyse_srum_database_json"
    "--skip=search_jq_simple_string"
    "--skip=search_q_jsonl_simple_string"
    "--skip=search_q_simple_string"
  ];

  meta = {
    description = "Rapidly Search and Hunt through Windows Forensic Artefacts";
    homepage = "https://github.com/WithSecureLabs/chainsaw";
    changelog = "https://github.com/WithSecureLabs/chainsaw/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "chainsaw";
  };
})
