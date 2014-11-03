{ stdenv, fetchurl, pkgconfig, gtk, gettext, ncurses }:

stdenv.mkDerivation rec {
  name = "girara-0.2.3";

  src = fetchurl {
    url = "http://pwmt.org/projects/girara/download/${name}.tar.gz";
    sha256 = "1phfmqp8y17zcy9yi6pm2f80x8ldbk60iswpm4bmjz5217jwqzxh";
  };

  buildInputs = [ pkgconfig gtk gettext ];

  makeFlags = [
    "PREFIX=$(out)"
    "TPUT=${ncurses}/bin/tput"
  ];

  meta = {
    homepage = http://pwmt.org/projects/girara/;
    description = "User interface library";
    longDescription = ''
      girara is a library that implements a GTK+ based VIM-like user interface
      that focuses on simplicity and minimalism.
    '';
    license = stdenv.lib.licenses.zlib;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.garbas ];
  };
}

