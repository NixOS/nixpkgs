{ stdenv, fetchurl, fetchpatch, pythonPackages, glibcLocales
, withGraphicalBackend ? false }:

pythonPackages.buildPythonApplication rec {
  name = "errbot-${version}";
  version = "5.0.1";

  src = fetchurl {
    url = "mirror://pypi/e/errbot/${name}.tar.gz";
    sha256 = "16kswcf844cxxp7hm7mksmv9w3b501dyn3swm54vq69y99iiynvy";
  };

  disabled = !pythonPackages.isPy3k;

  patches = [
    (fetchpatch {
      url = "https://github.com/mayflower/errbot/commit/3d360fded72cbd83376778bce124a0a2fcd7d621.patch";
      sha256 = "0qlninni6rgwk5fvcybpan3zppmchs34p4v9rzwnqqzhn4429mfh";
    })
    (fetchpatch {
      url = "https://github.com/mayflower/errbot/commit/87f3162e7b7809269e64453e7278022998dfe77e.patch";
      sha256 = "1kpanqb93d4w7v578amwldnbm5hfb1kqg024flb83hjyanik8839";
    })
  ];

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
  ] ++ stdenv.lib.optional withGraphicalBackend pyside;

  meta = with stdenv.lib; {
    description = "Chatbot designed to be simple to extend with plugins written in Python";
    homepage = http://errbot.io/;
    maintainers = with maintainers; [ fpletz globin ];
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
