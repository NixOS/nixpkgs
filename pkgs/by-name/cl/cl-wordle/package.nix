{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cl-wordle";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "conradludgate";
    repo = "wordle";
    rev = "v${version}";
    sha256 = "sha256-wFTvzAzboUFQg3fauIwIdRChK7rmLES92jK+8ff1D3s=";
  };

  cargoHash = "sha256-PtJbLpAUH44alupFY6wX++t/QsKknn5bXvnXzdYsd9o=";

  meta = with lib; {
    description = "Wordle TUI in Rust";
    homepage = "https://github.com/conradludgate/wordle";
    # repo has no license, but crates.io says it's MIT
    license = licenses.mit;
    maintainers = with maintainers; [ lom ];
    mainProgram = "wordle";
  };
}
