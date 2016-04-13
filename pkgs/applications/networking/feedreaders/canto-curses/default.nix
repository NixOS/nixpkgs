{ stdenv, fetchFromGitHub, python34Packages, readline, ncurses, canto-daemon }:

python34Packages.buildPythonApplication rec {
  version = "0.9.6";
  name = "canto-curses-${version}";

  src = fetchFromGitHub {
    owner = "themoken";
    repo = "canto-curses";
    rev = "v${version}";
    sha256 = "0hxzpx314cflxq68gswjf2vrqf1z1ci9mxhxgwrk7sa6di86ygy0";
  };

  buildInputs = [ readline ncurses canto-daemon ];
  propagatedBuildInputs = [ canto-daemon ];

  meta = {
    description = "An ncurses-based console Atom/RSS feed reader";
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
