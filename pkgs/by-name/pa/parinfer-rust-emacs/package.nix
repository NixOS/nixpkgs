{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "parinfer-rust-emacs";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "justinbarclay";
    repo = "parinfer-rust-emacs";
    rev = "v${version}";
    hash = "sha256-JYKFfbfpkvBRxYUDw2d6DD1mO27OKzdquSOhBk0lXr0=";
  };

  cargoHash = "sha256-E3x/Jy21qP1onABRmbrq51ZKrlqwiWIwSaqOCh28lKw=";

  meta = with lib; {
    description = "Emacs centric fork of parinfer-rust";
    mainProgram = "parinfer-rust";
    homepage = "https://github.com/justinbarclay/parinfer-rust-emacs";
    license = licenses.isc;
    maintainers = with maintainers; [ brsvh ];
  };
}
