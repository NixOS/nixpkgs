{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hexdino";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "Luz";
    repo = "hexdino";
    rev = version;
    hash = "sha256-glbyftCJiP0/5trW7DOcVCU2q4ZH3zFK96eyGuYR8eY=";
  };

  cargoHash = "sha256-NfVtNoTDGx3MGOe+bUOCgjSs8ZTfxMSCTp09sXOfUPs=";

  meta = with lib; {
    description = "Hex editor with vim like keybindings written in Rust";
    homepage = "https://github.com/Luz/hexdino";
    license = licenses.mit;
    maintainers = [ maintainers.luz ];
    mainProgram = "hexdino";
  };
}
