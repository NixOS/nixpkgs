{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hexdino";
<<<<<<< HEAD
  version = "0.1.4";
=======
  version = "0.1.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Luz";
    repo = "hexdino";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-M1lUm8rJj9c+9MgU7AJvk/ZVuTC1QYPsHRQxCQTc3WI=";
  };

  cargoHash = "sha256-IZhQ80iDO6l1FLAbq2l7QLpjoenkri3wBdQ6Mnz+BOI=";

  meta = {
    description = "Hex editor with vim like keybindings written in Rust";
    homepage = "https://github.com/Luz/hexdino";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.luz ];
=======
    hash = "sha256-glbyftCJiP0/5trW7DOcVCU2q4ZH3zFK96eyGuYR8eY=";
  };

  cargoHash = "sha256-NfVtNoTDGx3MGOe+bUOCgjSs8ZTfxMSCTp09sXOfUPs=";

  meta = with lib; {
    description = "Hex editor with vim like keybindings written in Rust";
    homepage = "https://github.com/Luz/hexdino";
    license = licenses.mit;
    maintainers = [ maintainers.luz ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "hexdino";
  };
}
