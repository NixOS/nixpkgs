{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "repeater";
  version = "0.1.10";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "shaankhosla";
    repo = "repeater";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8TWqY78w5cOirLnrBONiratAZQSQrYpp++5dXRlFlNo=";
  };

  cargoHash = "sha256-hngZ55o1YsnstBGjp8++9SsxwfUyu+X4YwZuzMupFTE=";

  # Disable the daily GitHub release check and the upgrade prompt, which do
  # not apply to a Nix installation.
  postPatch = ''
    substituteInPlace src/commands/check.rs \
      --replace-fail 'check_version::{check_version, prompt_for_new_version}' \
        'check_version::prompt_for_new_version' \
      --replace-fail 'tokio::spawn(check_version(db.clone()))' \
        'tokio::spawn(async { None })'
  '';

  # Tests in src/llm/secrets.rs point the same environment variable at
  # different auth files and race when run in parallel.
  dontUseCargoParallelTests = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Spaced repetition, in your terminal";
    homepage = "https://github.com/shaankhosla/repeater";
    changelog = "https://github.com/shaankhosla/repeater/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "repeater";
  };
})
