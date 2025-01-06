{
  lib,
  rustPlatform,
  fetchFromSourcehut,
}:

rustPlatform.buildRustPackage rec {
  pname = "kitty-img";
  version = "1.0.0";

  src = fetchFromSourcehut {
    owner = "~zethra";
    repo = "kitty-img";
    rev = version;
    hash = "sha256-5thx4ADmJE29bxN+ZO3hF0jhgXK+boqt8oj4Sygl5SU=";
  };

  cargoHash = "sha256-Ai1Esw83V3jbPDDQyNh8bTNLQBYBonIDkWP3AFgN78U=";

  meta = {
    description = "Print images inline in kitty";
    homepage = "https://git.sr.ht/~zethra/kitty-img";
    changelog = "https://git.sr.ht/~zethra/kitty-img/refs/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ gaykitty ];
    mainProgram = "kitty-img";
  };
}
