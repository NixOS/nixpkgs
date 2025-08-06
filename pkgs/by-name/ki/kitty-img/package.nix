{
  lib,
  rustPlatform,
  fetchFromSourcehut,
}:

rustPlatform.buildRustPackage rec {
  pname = "kitty-img";
  version = "1.1.0";

  src = fetchFromSourcehut {
    owner = "~zethra";
    repo = "kitty-img";
    rev = version;
    hash = "sha256-liqLocNIIOmkVWI8H9WU7T352sK7sceVtOX+R0BQ/uk=";
  };

  cargoHash = "sha256-50M1TUGvjELARt/gvtyAPNL0hG1ekKwdefI9nMEsTo0=";

  meta = {
    description = "Print images inline in kitty";
    homepage = "https://git.sr.ht/~zethra/kitty-img";
    changelog = "https://git.sr.ht/~zethra/kitty-img/refs/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ gaykitty ];
    mainProgram = "kitty-img";
  };
}
