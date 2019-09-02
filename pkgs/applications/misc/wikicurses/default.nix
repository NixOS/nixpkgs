{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "1.4";
  pname = "wikicurses";

  src = fetchFromGitHub {
    owner = "ids1024";
    repo = "wikicurses";
    rev = "v${version}";
    sha256 = "0f14s4qx3q5pr5vn460c34b5mbz2xs62d8ljs3kic8gmdn8x2knm";
  };

  propagatedBuildInputs = with pythonPackages; [ urwid beautifulsoup4 lxml ];

  meta = {
    description = "A simple curses interface for MediaWiki sites such as Wikipedia";
    homepage = https://github.com/ids1024/wikicurses/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ pSub ];
  };

}

