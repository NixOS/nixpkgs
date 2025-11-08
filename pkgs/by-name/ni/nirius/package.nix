{
  lib,
  fetchFromSourcehut,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "nirius";
  version = "0.6.1";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "nirius";
    rev = "nirius-${version}";
    hash = "sha256-KAh45AcNB9Y4ahxamtI6/z3l1xg6yf17h4rnZl3w89I=";
  };

  cargoHash = "sha256-p123QvlB/j0b5kFjICcTI/5ZKL8pzGfIvH80doAhqFA=";

  meta = {
    description = "Utility commands for the niri wayland compositor";
    mainProgram = "nirius";
    homepage = "https://git.sr.ht/~tsdh/nirius";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ tylerjl ];
    platforms = lib.platforms.linux;
  };
}
