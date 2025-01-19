{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "chess-tui";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "thomas-mauran";
    repo = "chess-tui";
    rev = "${version}";
    hash = "sha256-LtxaZ/7p/lqStoUmckVVaegQp02Ci3L46fMFEgledj4=";
  };

  cargoHash = "sha256-RUnT5b9pBcopTPT/1J48xZ4pfn3C0mIuYTDvgf3zvn0=";

  meta = with lib; {
    description = "Chess TUI implementation in rust";
    homepage = "https://github.com/thomas-mauran/chess-tui";
    maintainers = with maintainers; [ ByteSudoer ];
    license = licenses.mit;
    mainProgram = "chess-tui";
  };
}
