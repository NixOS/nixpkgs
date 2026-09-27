{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "droast";
  version = "1.4.10";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "immanuwell";
    repo = "dockerfile-roast";
    tag = finalAttrs.version;
    hash = "sha256-/UeM75dXpYYZ1Y5MVUSHvfw2nmSoKWJwW22c6NXuj6o=";
  };

  cargoHash = "sha256-EZykAREpe5HnDXwGgx6wUzg9PXm8QIgmNZbncfqVb5k=";

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
