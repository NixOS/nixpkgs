{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chainsaw";
  version = "2.17.1";

  src = fetchFromGitHub {
    owner = "WithSecureLabs";
    repo = "chainsaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bS6xYFfbnD8ZgSzVt+CQWGhfQCFYfzj1pRjLVlk8QMg=";
  };

  cargoHash = "sha256-iWEerjilcwSms95v6Dinf2UCLeraOdO/TDi7gFBNdws=";

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
