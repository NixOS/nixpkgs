{ stdenv, fetchFromGitHub, python34Packages, }:

python34Packages.buildPythonApplication rec {
  version = "0.9.5";
  name = "canto-daemon-${version}";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "themoken";
    repo = "canto-next";
    rev = "v${version}";
    sha256 = "1ycwrg5n2il833mdxgzz07r0vb4rxz89rk5c6l9g5x33ifinykdq";
  };

  propagatedBuildInputs = with python34Packages; [ feedparser ];

  meta = {
    description = "Daemon for the canto Atom/RSS feed reader";
    longDescription = ''
      Canto is an Atom/RSS feed reader for the console that is meant to be
      quick, concise, and colorful. It's meant to allow you to crank through
      feeds like you've never cranked before by providing a minimal, yet
      information packed interface. No navigating menus. No dense blocks of
      unreadable white text. An interface with almost infinite customization
      and extensibility using the excellent Python programming language.
    '';
    homepage = http://codezen.org/canto-ng/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
