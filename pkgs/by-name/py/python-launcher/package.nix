{ lib, rustPlatform, fetchFromGitHub, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "python-launcher";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "brettcannon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wRKTBvLLo0Vvvh1GtF9hOnUHNpOeX950y1U+8JYBGoE=";
  };

  cargoHash = "sha256-+FtfL5jAGJrpnZaJDnDMvWC0D3Af0L466v9nqJkb+uA=";

  nativeCheckInputs = [ python3 ];

  useNextest = true;

  meta = with lib; {
    description = "Implementation of the `py` command for Unix-based platforms";
    homepage = "https://github.com/brettcannon/python-launcher";
    changelog = "https://github.com/brettcannon/python-launcher/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "py";
  };
}
