{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "amber-lsp";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "amber-lang";
    repo = "amber-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d5FJGeQol6NPVCbZ8F97s6jiV/JrbVJMcXwro2hBJfI=";
  };

  cargoHash = "sha256-YSoNYjru/CWEYNqSkjCKFDps3XmmCRo4VaZ6n/7pI5A=";

  __structuredAttrs = true;

  # Running the test suite in parallel exceeds the memory available in the sandbox.
  dontUseCargoParallelTests = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server protocol implementation for Amber";
    homepage = "https://github.com/amber-lang/amber-lsp";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ silicalet ];
    mainProgram = "amber-lsp";
    platforms = lib.platforms.unix;
  };
})
