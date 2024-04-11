{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "chess-tui";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "thomas-mauran";
    repo = "chess-tui";
    rev = "${version}";
    hash = "sha256-If2xShHuqdCeasP12ZzwvGJSIKFmqJs0Hv1fBhJKoU4=";
  };

  cargoHash = "sha256-TT4lVAttlT3knufMslSVxInn9QM0QJ9jyklzwhRikWA=";

  meta = with lib;{
    description = "A chess TUI implementation in rust";
    homepage = "https://github.com/thomas-mauran/chess-tui";
    maintainers = with maintainers; [ ByteSudoer ];
    license = licenses.mit;
    mainProgram = "chess-tui";
  };
}
