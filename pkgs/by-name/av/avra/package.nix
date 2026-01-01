{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "avra";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "Ro5bert";
    repo = "avra";
    tag = version;
    hash = "sha256-joOj89WZ9Si5fcu1w1VHj5fOcnB9N2313Yb29A+nCCY=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  doCheck = true;

<<<<<<< HEAD
  meta = {
    description = "Assembler for the Atmel AVR microcontroller family";
    mainProgram = "avra";
    homepage = "https://github.com/Ro5bert/avra";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Assembler for the Atmel AVR microcontroller family";
    mainProgram = "avra";
    homepage = "https://github.com/Ro5bert/avra";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
