{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  pname = "gopher";
  version = "3.0.11";

  src = fetchurl {
    url = "http://gopher.quux.org:70/devel/gopher/Downloads/gopher_${version}.tar.gz";
    sha256 = "15r7x518wlpfqpd6z0hbdwm8rw8ll8hbpskdqgxxhrmy00aa7w9c";
  };

  buildInputs = [ ncurses ];

  preConfigure = "export LIBS=-lncurses";

  meta = {
    homepage = http://gopher.quux.org:70/devel/gopher;
    description = "A ncurses gopher client";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ sternenseemann ];
  };
}
