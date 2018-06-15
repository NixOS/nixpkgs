{ stdenv, fetchurl, ncurses }:
stdenv.mkDerivation rec {

  name = "tudu-${version}";
  version = "0.10.2";

  src = fetchurl {
    url = "https://code.meskio.net/tudu/${name}.tar.gz";
    sha256 = "1xsncvd1c6v8y0dzc5mspy9rrwc89pabhz6r2lihsirk83h2rqym";
  };

  buildInputs = [ ncurses ];

  meta = {
    description = "ncurses-based hierarchical todo list manager with vim-like keybindings";
    homepage = https://code.meskio.net/tudu/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
