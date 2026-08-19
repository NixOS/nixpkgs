{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chainsaw";
  version = "2.16.3";

  src = fetchFromGitHub {
    owner = "WithSecureLabs";
    repo = "chainsaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dG3WxAWnMBMlV3HxI9E7EDvZgK+qYZwRiZVNRf7jekY=";
  };

  cargoHash = "sha256-t9Adw4W7m1jWsLhwEtIgJjAWDxRkpOzssKe98InOExQ=";

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
