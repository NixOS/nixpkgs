{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  version = "0.9.8";
  format = "setuptools";
  pname = "canto-daemon";

  src = fetchFromGitHub {
    owner = "themoken";
    repo = "canto-next";
    rev = "v${version}";
    sha256 = "0fmsdn28z09bvivdkqcla5bnalky7k744iir25z70bv4pz1jcvnk";
  };

  propagatedBuildInputs = with python3Packages; [ feedparser ];

  doCheck = false;

  pythonImportsCheck = [ "canto_next" ];

  meta = with lib; {
    description = "Daemon for the canto Atom/RSS feed reader";
    longDescription = ''
      Canto is an Atom/RSS feed reader for the console that is meant to be
      quick, concise, and colorful. It's meant to allow you to crank through
      feeds like you've never cranked before by providing a minimal, yet
      information packed interface. No navigating menus. No dense blocks of
      unreadable white text. An interface with almost infinite customization
      and extensibility using the excellent Python programming language.
    '';
    homepage = "https://codezen.org/canto-ng/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ devhell ];
  };
}
