{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "gopher";
  version = "3.0.18";

  src = fetchFromGitHub {
    owner = "jgoerzen";
    repo = "gopher";
    rev = "release/${version}";
    sha256 = "sha256-YAcpEV3SbiUZ4nqYk6k1M41YWdTGSSH7rNB15gv31qQ=";
  };

  buildInputs = [ ncurses ];

  patches = [
    ./int_main.patch # https://github.com/jgoerzen/gopher/pull/8
  ];

  preConfigure = "export LIBS=-lncurses";

  meta = with lib; {
    homepage = "http://gopher.quux.org:70/devel/gopher";
    description = "Ncurses gopher client";
    platforms = platforms.linux; # clang doesn't like local regex.h
    license = licenses.gpl2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
