{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "backdown";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "backdown";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3+XmMRZz3SHF1sL+/CUvu4uQ2scE4ACpcC0r4nWhdkM=";
  };

  cargoHash = "sha256-qVE4MOFr0YO+9rAbfnz92h0KocaLu+v2u5ompwY/o6k=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "File deduplicator";
    homepage = "https://github.com/Canop/backdown";
    changelog = "https://github.com/Canop/backdown/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.progrm_jarvis ];
    mainProgram = "backdown";
  };
})
