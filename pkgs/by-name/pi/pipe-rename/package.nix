{
  lib,
  rustPlatform,
  fetchCrate,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "pipe-rename";
  version = "1.6.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-av/ig76O7t3dB4Irfi3yqyL30nkJJCzs5EayWRbpOI0=";
  };

  cargoHash = "sha256-3p6Bf9UfCb5uc5rp/yuXixcDkuXfTiboLl8TI0O52hE=";

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
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "renamer";
  };
}
