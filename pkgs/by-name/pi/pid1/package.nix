{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "pid1";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "fpco";
    repo = "pid1-rs";
    rev = "v${version}";
    hash = "sha256-2dnQj3AQxedyq1YvHKt+lVXNEtuB5sMRSCqX9YeifzI=";
  };

  cargoHash = "sha256-/KK9U1dgCLglgn/MJ7+sov4EEnY/nluEsz0ooMp6ggI=";

  meta = with lib; {
    description = "Signal handling and zombie reaping for PID1 process";
    homepage = "https://github.com/fpco/pid1-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
    mainProgram = "pid1";
  };
}
