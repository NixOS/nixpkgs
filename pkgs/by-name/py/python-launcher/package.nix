{
  lib,
  rustPlatform,
  fetchFromGitHub,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "python-launcher";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "brettcannon";
    repo = "python-launcher";
    rev = "v${version}";
    sha256 = "sha256-wRKTBvLLo0Vvvh1GtF9hOnUHNpOeX950y1U+8JYBGoE=";
  };

  cargoHash = "sha256-rWawf1YYeTWKPaZwua/f4BNo56z3mkCBU4jyZIFNqP4=";

  nativeCheckInputs = [ python3 ];

  useNextest = true;

  meta = {
    description = "Implementation of the `py` command for Unix-based platforms";
    homepage = "https://github.com/brettcannon/python-launcher";
    changelog = "https://github.com/brettcannon/python-launcher/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "py";
  };
}
