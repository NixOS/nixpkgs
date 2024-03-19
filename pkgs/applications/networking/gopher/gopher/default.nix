{ lib, stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  pname = "gopher";
  version = "3.0.17";

  src = fetchFromGitHub {
    owner = "jgoerzen";
    repo = pname;
    rev = "release/${version}";
    sha256 = "1j6xh5l8v231d4mwl9gj1c34dc0jmazz6zg1qqfxmqr9y609jq3h";
  };

  buildInputs = [ ncurses ];

  preConfigure = "export LIBS=-lncurses";

  meta = with lib; {
    homepage = "http://gopher.quux.org:70/devel/gopher";
    description = "A ncurses gopher client";
    platforms = platforms.linux; # clang doesn't like local regex.h
    license = licenses.gpl2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
