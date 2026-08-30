{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "avra";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "Ro5bert";
    repo = "avra";
    tag = finalAttrs.version;
    hash = "sha256-joOj89WZ9Si5fcu1w1VHj5fOcnB9N2313Yb29A+nCCY=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  doCheck = true;

  meta = {
    description = "Assembler for the Atmel AVR microcontroller family";
    mainProgram = "avra";
    homepage = "https://github.com/Ro5bert/avra";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
