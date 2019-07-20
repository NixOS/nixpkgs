{ stdenv, fetchFromGitHub, python3Packages, }:

python3Packages.buildPythonApplication rec {
  version = "0.9.7";
  pname = "canto-daemon";

  src = fetchFromGitHub {
    owner = "themoken";
    repo = "canto-next";
    rev = "v${version}";
    sha256 = "1si53r8cd4avfc56r315zyrghkppnjd6n125z1agfv59i7hdmk3n";
  };

  propagatedBuildInputs = with python3Packages; [ feedparser ];

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
    homepage = https://codezen.org/canto-ng/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
