{
  lib,
  rustPlatform,
  fetchCrate,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "pipe-rename";
  version = "1.6.6";

  src = fetchCrate {
    inherit pname version;
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

  meta = with lib; {
    description = "Rename your files using your favorite text editor";
    homepage = "https://github.com/marcusbuffett/pipe-rename";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "renamer";
  };
}
