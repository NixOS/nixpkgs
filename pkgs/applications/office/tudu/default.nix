{ stdenv, fetchurl, ncurses }:
stdenv.mkDerivation rec {

  pname = "tudu";
  version = "0.10.3";

  src = fetchurl {
    url = "https://code.meskio.net/tudu/${pname}-${version}.tar.gz";
    sha256 = "0140pw457cd05ysws998yhd3b087j98q8m0g3s4br942l65b8n2y";
  };

  buildInputs = [ ncurses ];

  meta = {
    description = "ncurses-based hierarchical todo list manager with vim-like keybindings";
    homepage = https://code.meskio.net/tudu/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
