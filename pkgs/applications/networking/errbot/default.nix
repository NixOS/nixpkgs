{ lib
, fetchFromGitHub
, glibcLocales
, python39
}:

let
  python3 = python39;
in python3.pkgs.buildPythonApplication rec {
  pname = "errbot";
  version = "6.1.7";

  src = fetchFromGitHub {
    owner = "errbotio";
    repo = "errbot";
    rev = version;
    sha256 = "02h44qd3d91zy657hyqsw3gskgxg31848pw6zpb8dhd1x84z5y77";
  };

  LC_ALL = "en_US.utf8";

  buildInputs = [ glibcLocales ];

  propagatedBuildInputs = with python3.pkgs; [
    ansi
    colorlog
    daemonize
    deepmerge
    dulwich
    flask
    hypchat
    irc
    jinja2
    markdown
    pyasn1
    pyasn1-modules
    pygments
    pygments-markdown-lexer
    pyopenssl
    requests
    slackclient
    sleekxmpp
    telegram
    webtest
  ];

  nativeCheckInputs = with python3.pkgs; [
    mock
    pytestCheckHook
  ];

  # Slack backend test has an import issue
  pytestFlagsArray = [ "--ignore=tests/backend_tests/slack_test.py" ];

  disabledTests = [
    "backup"
    "broken_plugin"
    "plugin_cycle"
  ];

  pythonImportsCheck = [ "errbot" ];

  meta = with lib; {
    description = "Chatbot designed to be simple to extend with plugins written in Python";
    homepage = "http://errbot.io/";
    maintainers = with maintainers; [ globin ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    # flaky on darwin, "RuntimeError: can't start new thread"
  };
}
