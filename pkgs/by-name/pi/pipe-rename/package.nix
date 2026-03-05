{
  lib,
  rustPlatform,
  fetchCrate,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "pipe-rename";
  version = "1.6.7";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-9Pub+OCN+PiKHfCxflwkHp6JNSB8AqAtKsNTlAsANbA=";
  };

  cargoHash = "sha256-oYJNiUIi/uYxzd9DfgBgEaEy3g32r44seI56ur9UMcc=";

  nativeCheckInputs = [ python3 ];

  checkFlags = [
    # tests are failing upstream
    "--skip=test_dot"
    "--skip=test_dotdot"
  ];

  preCheck = ''
    patchShebangs tests/editors/env-editor.py
  '';

  meta = {
    description = "Rename your files using your favorite text editor";
    homepage = "https://github.com/marcusbuffett/pipe-rename";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "renamer";
  };
}
