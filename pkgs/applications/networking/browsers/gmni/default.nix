{ stdenv, lib, fetchFromSourcehut, pkg-config, bearssl, scdoc }:

stdenv.mkDerivation rec {
  pname = "gmni";
  version = "unstable-2021-03-26";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "gmni";
    rev = "77b73efbcd3ea7ed9e3e4c0aa19d9247e21d3c87";
    sha256 = "1wvnzyv7vyddcd39y6q5aflpnnsdl4k4y5aj5ssb7vgkld0h1b7r";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ bearssl scdoc ];

  meta = with lib; {
    description = "A Gemini client";
    homepage = "https://git.sr.ht/~sircmpwn/gmni";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ bsima jb55 ];
    platforms = platforms.all;
  };
}
