{
  lib,
  rustPlatform,
  fetchCrate,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "pipe-rename";
<<<<<<< HEAD
  version = "1.6.6";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-eZldAhqmoIkNZaI6r31hI43KCPDDeWk3fKpY3/BaUQE=";
  };

  cargoHash = "sha256-9xOL8qtUha4dL7V+GC8TnPGjBprKADqzIwOqqMyPB5A=";
=======
  version = "1.6.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-av/ig76O7t3dB4Irfi3yqyL30nkJJCzs5EayWRbpOI0=";
  };

  cargoHash = "sha256-0+m11mPR/s45MeY90WM3vmnGk6Xb0j2DJnZrEZ/EX1g=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeCheckInputs = [ python3 ];

  checkFlags = [
    # tests are failing upstream
    "--skip=test_dot"
    "--skip=test_dotdot"
  ];

  preCheck = ''
    patchShebangs tests/editors/env-editor.py
  '';

<<<<<<< HEAD
  meta = {
    description = "Rename your files using your favorite text editor";
    homepage = "https://github.com/marcusbuffett/pipe-rename";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Rename your files using your favorite text editor";
    homepage = "https://github.com/marcusbuffett/pipe-rename";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "renamer";
  };
}
