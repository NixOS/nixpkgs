{
  lib,
  rustPlatform,
  fetchFromGitHub,
  python3,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustpython";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "RustPython";
    repo = "RustPython";
    tag = version;
    hash = "sha256-BYYqvPJu/eFJ9lt07A0p7pd8pGFccUe/okFqGEObhY4=";
  };

  cargoHash = "sha256-LuxET01n5drYmPXXhCl0Cs9yoCQKwWah8FWfmKmLdsg=";

  # freeze the stdlib into the rustpython binary
  cargoBuildFlags = [ "--features=freeze-stdlib" ];

  nativeCheckInputs = [ python3 ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Python 3 interpreter in written Rust";
    homepage = "https://rustpython.github.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
    mainProgram = "rustpython";
  };
}
