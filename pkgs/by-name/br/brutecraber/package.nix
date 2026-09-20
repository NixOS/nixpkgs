{
  lib,
  fetchFromGitHub,
  nix-update-script,
  ocl-icd,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "brutecraber";
  version = "0.9.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Erikgavs";
    repo = "brutecraber";
    tag = finalAttrs.version;
    hash = "sha256-rTSusRTh+7pPnKdhfyLMAFhsFcQkfFlYUxRJeulv0Ho=";
  };

  cargoHash = "sha256-b+LrTAW21To7UZC+Rh3NkDGDCrXgiOHUkhE7OFJsBHs=";

  buildInputs = [ ocl-icd ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hash cracker";
    homepage = "https://github.com/Erikgavs/brutecraber";
    changelog = "https://github.com/Erikgavs/brutecraber/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "brutecraber";
  };
})
