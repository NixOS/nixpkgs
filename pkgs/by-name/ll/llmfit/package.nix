{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "llmfit";
  version = "1.1.16";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AlexsJones";
    repo = "llmfit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EMCtdgfR4y9+UY3byg+jYUhkcWpt1ZU8/CIOHnMY3UQ=";
  };

  cargoHash = "sha256-aQEThRrqTh4m3KMJqCU4vcMGrQiIR23yiSibTIAywB8=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  # These seem to rely on system state that we do not have inside nix builds
  checkFlags = [
    "--skip=json_apple_gpu_skips_successful_text_probe"
    "--skip=json_apple_gpu_survives_failed_text_probe"
    "--skip=text_probe_recovers_when_json_fails"
  ];

  meta = {
    description = "TUI to find LLM models right sized for the system's RAM, CPU, and GPU";
    homepage = "https://github.com/AlexsJones/llmfit";
    changelog = "https://github.com/AlexsJones/llmfit/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "llmfit";
  };
})
