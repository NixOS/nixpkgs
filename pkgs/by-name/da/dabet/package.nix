{
  lib,
  rustPlatform,
  fetchFromGitea,
}:

rustPlatform.buildRustPackage rec {
  pname = "dabet";
  version = "3.0.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "dabet";
    rev = "v${version}";
    hash = "sha256-BYE+GGwf84zENf+lPS98OzZQbXxd7kykWL+B3guyVNI=";
  };

  cargoHash = "sha256-2ixdugxgc6lyLd06BeXxlrSqpVGJJ9SkFKwnAsol7V4=";

  meta = {
    description = "Print the duration between two times";
    homepage = "https://codeberg.org/annaaurora/dabet";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ annaaurora ];
    mainProgram = "dabet";
  };
}
