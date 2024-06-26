{ lib, stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "bvi";
  version = "1.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/bvi/${pname}-${version}.src.tar.gz";
    sha256 = "sha256-S7oWwrSWljqbk5M2wKvMjUiGZEkggK5DqG2hjPTOlPI=";
  };

  buildInputs = [ ncurses ];

  meta = with lib; {
    description = "Hex editor with vim style keybindings";
    homepage = "https://bvi.sourceforge.net/download.html";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux ++ darwin;
  };
}
