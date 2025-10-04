{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "bvi";
  version = "1.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/bvi/${pname}-${version}.src.tar.gz";
    sha256 = "sha256-ZUBxaho7K5cRY1EI2hSya66kiIgdSmghIcC927prdMs=";
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
