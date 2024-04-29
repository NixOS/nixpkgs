{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bloat";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vPk6ERl0VM1TjK/JRMcXqCvKqSTuw78MsmQ0xImQyd4=";
  };

  cargoHash = "sha256-6fMFGLH16Z1O+ETlr0685TXHup1vJetfzPdNC2Lw9uM=";

  meta = with lib; {
    description = "A tool and Cargo subcommand that helps you find out what takes most of the space in your executable";
    homepage = "https://github.com/RazrFalcon/cargo-bloat";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ xrelkd matthiasbeyer ];
    mainProgram = "cargo-bloat";
  };
}
