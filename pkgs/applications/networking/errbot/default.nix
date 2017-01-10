{ stdenv, fetchurl, fetchpatch, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "errbot-${version}";
  version = "4.3.3";

  src = fetchurl {
    url = "mirror://pypi/e/errbot/${name}.tar.gz";
    sha256 = "1z6xcm8jx22i56gpcrjym85a82swvaxh09zkryd5pdksi6k41rb4";
  };

  disabled = !pythonPackages.isPy3k;

  patches = [
    (fetchpatch {
      url = "https://github.com/mayflower/errbot/commit/d6890c2e02e145b0344a5ea05fd5874218fa40ff.patch";
      sha256 = "0qlninni6rgwk5fvcybpan3zppmchs34p4v9rzwnqqzhn4429mfh";
    })
    (fetchpatch {
      url = "https://github.com/mayflower/errbot/commit/3705817fe2dfe957b35c5523bee8d85fa2d5f8f8.patch";
      sha256 = "1whz72p5hjlwkriiql76vvc3lz1n171p9n0p4mk3mwgapgmwavd8";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace dnspython3 dnspython
  '';

  # tests folder is not included in release
  doCheck = false;

  propagatedBuildInputs = with pythonPackages; [
    webtest bottle threadpool rocket-errbot requests2 jinja2
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
