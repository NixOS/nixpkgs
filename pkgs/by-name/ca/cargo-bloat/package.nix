{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bloat";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-B71VX7cJe1giOLmk3cQE8Zxr7fKGyQkoXRuM+NzBcb8=";
  };

  cargoHash = "sha256-BBFLyMx1OPT2XAM6pofs2kV/3n3FrNu0Jkyr/Y3smnI=";

  meta = with lib; {
    description = "A tool and Cargo subcommand that helps you find out what takes most of the space in your executable";
    homepage = "https://github.com/RazrFalcon/cargo-bloat";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      xrelkd
      matthiasbeyer
    ];
    mainProgram = "cargo-bloat";
  };
}
