{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "errbot-${version}";
  version = "4.2.2";

  src = fetchurl {
    url = "mirror://pypi/e/errbot/${name}.tar.gz";
    sha256 = "1f1nw4m58dvmw0a37gbnihgdxxr3sz0l39653jigq9ysh3nznifv";
  };

  disabled = !pythonPackages.isPy3k;

  patches = [
    ./fix-dnspython.patch
  ];

  buildInputs = with pythonPackages; [
    pep8 mock pytest pytest_xdist
  ];

  propagatedBuildInputs = with pythonPackages; [
    webtest bottle threadpool rocket-errbot requests2 jinja2
    pyopenssl colorlog Yapsy markdown ansi pygments dns pep8
    daemonize pygments-markdown-lexer telegram irc slackclient
    pyside sleekxmpp hypchat
  ];

  meta = with stdenv.lib; {
    description = "Chatbot designed to be simple to extend with plugins written in Python";
    homepage = http://errbot.io/;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
