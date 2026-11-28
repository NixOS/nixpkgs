{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "droast";
  version = "1.8.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "immanuwell";
    repo = "dockerfile-roast";
    tag = finalAttrs.version;
    hash = "sha256-9vk3GM/mPt79+gytKIZczQC6LqhDYWwSAIHBGIrBv3g=";
  };

  cargoHash = "sha256-tPLeZwban3tCw8XeBItpWjoavTA4vprY9vnaDjG25VA=";

  # Some CLI tests require the source tree to be a Git checkout, which is not
  # available from the release archive used by fetchFromGitHub.
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Opinionated Dockerfile linter";
    homepage = "https://github.com/immanuwell/dockerfile-roast";
    changelog = "https://github.com/immanuwell/dockerfile-roast/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.immanuwell ];
    mainProgram = "droast";
  };
})
