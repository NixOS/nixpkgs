{ lib
, autoreconfHook
, fetchFromGitHub
, gettext
, ncurses
, readline
, stdenv
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "pinfo";
  version = "0.6.13";

  src = fetchFromGitHub {
    owner = "baszoetekouw";
    repo = pname;
    rev = "v${version}";
    sha256 = "173d2p22irwiabvr4z6qvr6zpr6ysfkhmadjlyhyiwd7z62larvy";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    gettext
    texinfo
    ncurses
    readline
  ];

  configureFlags = [
    "--with-curses=${ncurses.dev}"
    "--with-readline=${readline.dev}"
  ];

  meta = with lib; {
    description = "A viewer for info files";
    homepage = "https://github.com/baszoetekouw/pinfo";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fab ];
  };
}
