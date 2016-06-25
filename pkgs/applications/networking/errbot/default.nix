{ fetchurl, python3Packages }:

python3Packages.buildPythonPackage rec {
  name = "errbot-${version}";
  version = "4.2.2";

  src = fetchurl {
    url = "mirror://pypi/e/errbot/${name}.tar.gz";
    sha256 = "1f1nw4m58dvmw0a37gbnihgdxxr3sz0l39653jigq9ysh3nznifv";
  };

  patches = [
    ./fix-dnspython.patch
  ];

  buildInputs = with python3Packages; [
    pep8 mock pytest pytest_xdist
  ];

  propagatedBuildInputs = with python3Packages; [
    webtest bottle threadpool rocket-errbot requests2 jinja2
    pyopenssl colorlog Yapsy markdown ansi pygments dns pep8
    daemonize pygments-markdown-lexer telegram irc slackclient
    pyside sleekxmpp hypchat
  ];
}


