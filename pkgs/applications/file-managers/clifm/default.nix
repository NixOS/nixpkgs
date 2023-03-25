{ stdenv, lib, fetchFromGitHub, libcap, acl, file, readline, gettext }:

with lib;

stdenv.mkDerivation rec {
  pname = "clifm";
  version = "1.13";

  src = fetchFromGitHub {
    owner = "leo-arch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Y9z3HT36Z1fwweOnniRgyNQX1cbrLSGGgB5UAxkq9mI=";
  };

  buildInputs = [ file readline ]
  ++ optionals (!stdenv.isDarwin) [ libcap acl ]
  ++ optional stdenv.isDarwin gettext;

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "DATADIR=/share"
    "PREFIX=/"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/leo-arch/clifm";
    description = "CliFM is a CLI-based, shell-like, and non-curses terminal file manager written in C: simple, fast, extensible, and lightweight as hell";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ mimame ];
    platforms = platforms.unix;
  };
}
