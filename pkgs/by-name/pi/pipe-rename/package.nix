{
  lib,
  rustPlatform,
  fetchCrate,
  python3,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pipe-rename";
  version = "1.6.6";

  src = fetchCrate {
    pname = "pipe-rename";
    inherit (finalAttrs) version;
    hash = "sha256-eZldAhqmoIkNZaI6r31hI43KCPDDeWk3fKpY3/BaUQE=";
  };

  cargoHash = "sha256-9xOL8qtUha4dL7V+GC8TnPGjBprKADqzIwOqqMyPB5A=";

  nativeCheckInputs = [ python3 ];

  checkFlags = [
    # tests are failing upstream
    "--skip=test_dot"
    "--skip=test_dotdot"
  ];

  preCheck = ''
    patchShebangs tests/editors/env-editor.py
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rename your files using your favorite text editor";
    homepage = "https://github.com/marcusbuffett/pipe-rename";
    changelog = "https://github.com/marcusbuffett/pipe-rename/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.progrm_jarvis ];
    mainProgram = "renamer";
  };
})
