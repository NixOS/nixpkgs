{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dix";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "faukah";
    repo = "dix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X+yFRLorfq9jvyMCvVCYUCh1pVN207XqTDr2FM1C+QE=";
  };

  cargoHash = "sha256-Y9cTncgTfv+mr5izioLF3wb6ZRBWe0eKAZ2iqcsf/Tk=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/faukah/dix";
    description = "Blazingly fast tool to diff Nix related things";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      faukah
      NotAShelf
    ];
    mainProgram = "dix";
  };
})
