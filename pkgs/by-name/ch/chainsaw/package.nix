{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chainsaw";
  version = "2.16.5";

  src = fetchFromGitHub {
    owner = "WithSecureLabs";
    repo = "chainsaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BTN+yDeiP47UEPNEYoWMRbaKPZY+dvyeUUw3M/4Lr3I=";
  };

  cargoHash = "sha256-xIh5a+0xvpbuoL3J6WETJ+BjFLmNwJXemn2KXPOFZpU=";

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
