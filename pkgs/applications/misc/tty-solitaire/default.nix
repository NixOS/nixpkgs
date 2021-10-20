{ lib, stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  pname = "tty-solitaire";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "mpereira";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zMLNWJieHxHALFQoSkdAxGbUBGuZnznLX86lI3P21F0=";
  };

  buildInputs = [ ncurses ];

  patchPhase = "sed -i -e '/^CFLAGS *?= *-g *$/d' Makefile";

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Klondike Solitaire in your ncurses terminal";
    license = licenses.mit;
    homepage = "https://github.com/mpereira/tty-solitaire";
    platforms = ncurses.meta.platforms;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
