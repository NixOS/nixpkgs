{ stdenv, fetchurl, ncurses }:
stdenv.mkDerivation rec {

  name = "tudu-${version}";
  version = "0.10";

  src = fetchurl {
    url = "http://code.meskio.net/tudu/${name}.tar.gz";
    sha256 = "0571wh5hn0hgadyx34zq1zi35pzd7vpwkavm7kzb9hwgn07443x4";
  };

  buildInputs = [ ncurses ];

  meta = {
    description = "ncurses-based hierarchical todo list manager with vim-like keybindings";
    homepage = http://code.meskio.net/tudu/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
