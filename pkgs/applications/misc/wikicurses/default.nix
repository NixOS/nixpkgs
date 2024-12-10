{
  lib,
  fetchFromGitHub,
  pythonPackages,
}:

pythonPackages.buildPythonApplication rec {
  version = "1.4";
  pname = "wikicurses";

  src = fetchFromGitHub {
    owner = "ids1024";
    repo = "wikicurses";
    rev = "v${version}";
    sha256 = "0f14s4qx3q5pr5vn460c34b5mbz2xs62d8ljs3kic8gmdn8x2knm";
  };

  outputs = [
    "out"
    "man"
  ];

  propagatedBuildInputs = with pythonPackages; [
    urwid
    beautifulsoup4
    lxml
  ];

  postInstall = ''
    mkdir -p $man/share/man/man{1,5}
    cp wikicurses.1 $man/share/man/man1/
    cp wikicurses.conf.5 $man/share/man/man5/
  '';

  doCheck = false;

  meta = {
    description = "A simple curses interface for MediaWiki sites such as Wikipedia";
    mainProgram = "wikicurses";
    homepage = "https://github.com/ids1024/wikicurses/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pSub ];
  };

}
