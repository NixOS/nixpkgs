{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dix";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "faukah";
    repo = "dix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gq5Nr6xVGpAf1XnYrmoeyvqVgffAi8R6QETJU3xv22M=";
  };

  cargoHash = "sha256-IEsZNuLXKa+MInuortG4ifHTZ0Ngs0ugm02BK6shzHA=";

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
