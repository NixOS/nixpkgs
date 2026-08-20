{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chainsaw";
  version = "2.16.4";

  src = fetchFromGitHub {
    owner = "WithSecureLabs";
    repo = "chainsaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J+yIAhiZE1MK5lGZtlxqmElrO/KqEdtkKE4nKPxMGzw=";
  };

  cargoHash = "sha256-q959QVqdISSI2SkUgamtR29DKd7oF/5eGsXpwHir1nE=";

  ldflags = [ "-s" ];

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  checkFlags = [
    # Tests are failing
    "--skip=analyse_srum_database_json"
    "--skip=search_jq_simple_string"
    "--skip=search_q_jsonl_simple_string"
    "--skip=search_q_simple_string"
  ];

  doInstallCheck = true;

  meta = {
    description = "Rapidly Search and Hunt through Windows Forensic Artefacts";
    homepage = "https://github.com/WithSecureLabs/chainsaw";
    changelog = "https://github.com/WithSecureLabs/chainsaw/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "chainsaw";
  };
})
