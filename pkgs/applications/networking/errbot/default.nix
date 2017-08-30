{ stdenv, fetchurl, pythonPackages, glibcLocales }:

pythonPackages.buildPythonApplication rec {
  name = "errbot-${version}";
  version = "5.1.2";

  src = fetchurl {
    url = "mirror://pypi/e/errbot/${name}.tar.gz";
    sha256 = "1r9w7pmdw77h1hwxns6d0sdg8cndsq1lwkq0y5qiiqr91jz93ajm";
  };

  disabled = !pythonPackages.isPy3k;

  LC_ALL = "en_US.utf8";

  postPatch = ''
    substituteInPlace setup.py \
      --replace dnspython3 dnspython
  '';

  # tests folder is not included in release
  doCheck = false;

  buildInputs = [ glibcLocales ];
  propagatedBuildInputs = with pythonPackages; [
    webtest bottle threadpool rocket-errbot requests jinja2
    pyopenssl colorlog Yapsy markdown ansi pygments dns pep8
    daemonize pygments-markdown-lexer telegram irc slackclient
    sleekxmpp hypchat pytest
  ];

  meta = with stdenv.lib; {
    description = "Chatbot designed to be simple to extend with plugins written in Python";
    homepage = http://errbot.io/;
    maintainers = with maintainers; [ fpletz globin ];
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
