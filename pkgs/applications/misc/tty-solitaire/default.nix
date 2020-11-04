{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  pname = "tty-solitaire";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "mpereira";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kix7wfy2bda8cw5kfm7bm5acd5fqmdl9g52ms9bza4kf2jnb754";
  };

  buildInputs = [ ncurses ];

  patchPhase = "sed -i -e '/^CFLAGS *?= *-g *$/d' Makefile";

  makeFlags = [ "CC=cc" "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "Klondike Solitaire in your ncurses terminal";
    license = licenses.mit;
    homepage = "https://github.com/mpereira/tty-solitaire";
    platforms = ncurses.meta.platforms;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
