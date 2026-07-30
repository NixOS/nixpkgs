{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chainsaw";
  version = "2.16.2";

  src = fetchFromGitHub {
    owner = "WithSecureLabs";
    repo = "chainsaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EKL2MTo5qirpY4TCWwBptpRWJRd6Yp/dLz/5sIsdsbg=";
  };

  cargoHash = "sha256-bbgRqp3bNw2U69aVqwvJNWOKgW0YhR8SlqzH9jdrHZU=";

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
