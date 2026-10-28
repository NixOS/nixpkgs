{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  ocl-icd,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "brutecraber";
  version = "0.10.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Erikgavs";
    repo = "brutecraber";
    tag = finalAttrs.version;
    hash = "sha256-2NbSqLa9+NIkdmiuSsX243xoZXc5DL1canlC/31nWXU=";
  };

  cargoHash = "sha256-+jBNcwgR+HNzfDZ+SBFl+zmQgGJpl7ZyQzBRrDpZmPU=";

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
    broken = stdenv.hostPlatform.isDarwin;
  };
})
