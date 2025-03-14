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

  useFetchCargoVendor = true;
  cargoHash = "sha256-Ydn/y7HF8VppEjkRy3ayibgxpcLc1NiHlR5oLi3D11A=";

  meta = with lib; {
    description = "Chess TUI implementation in rust";
    homepage = "https://github.com/thomas-mauran/chess-tui";
    maintainers = with maintainers; [ ByteSudoer ];
    license = licenses.mit;
    mainProgram = "chess-tui";
  };
}
