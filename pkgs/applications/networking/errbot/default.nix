{ stdenv, fetchurl, pythonPackages, glibcLocales }:

pythonPackages.buildPythonApplication rec {
  name = "errbot-${version}";
  version = "5.1.3";

  src = fetchurl {
    url = "mirror://pypi/e/errbot/${name}.tar.gz";
    sha256 = "0nkfq6fx87g7kvxrb5lp8gkb75658cmyffnacpy8jq3a16py3jrr";
  };

  disabled = !pythonPackages.isPy3k;

  LC_ALL = "en_US.utf8";

  postPatch = ''
    substituteInPlace setup.py \
      --replace dnspython3 dnspython \
      --replace 'cryptography<2.1.0' cryptography \
      --replace 'pyOpenSSL<17.3.0' pyOpenSSL
  '';

  # tests folder is not included in release
  doCheck = false;

  buildInputs = [ glibcLocales ];
  propagatedBuildInputs = with pythonPackages; [
    webtest bottle threadpool rocket-errbot requests jinja2
    pyopenssl colorlog Yapsy markdown ansi pygments dnspython pep8
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
