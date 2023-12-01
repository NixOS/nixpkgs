{ stdenv, lib, fetchFromSourcehut, bearssl, scdoc }:

stdenv.mkDerivation rec {
  pname = "gmni";
  version = "1.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "gmni";
    rev = version;
    sha256 = "sha256-3MFNAI/SfFigNfitfFs3o9kkz7JeEflMHiH7iJpLfi4=";
  };

  nativeBuildInputs = [ scdoc ];
  buildInputs = [ bearssl ];

  meta = with lib; {
    description = "A Gemini client";
    homepage = "https://git.sr.ht/~sircmpwn/gmni";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ bsima jb55 ];
    platforms = platforms.linux;
  };
}
