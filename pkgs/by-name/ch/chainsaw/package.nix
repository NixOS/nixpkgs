{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chainsaw";
  version = "2.18.0";

  src = fetchFromGitHub {
    owner = "WithSecureOpenSource";
    repo = "chainsaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JHKpA4KssnU2MDGDmQ+r4vIFzMAxKRyYbSr81MWI1YE=";
  };

  cargoHash = "sha256-qZPdTEySJJvQ5/VOHeS3PjxLdqYWClerUXXq4lNI/Gc=";

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
    homepage = "https://github.com/WithSecureOpenSource/chainsaw";
    changelog = "https://github.com/WithSecureOpenSource/chainsaw/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "chainsaw";
  };
})
