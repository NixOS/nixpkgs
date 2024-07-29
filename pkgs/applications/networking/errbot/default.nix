{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "errbot";
  version = "6.2.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "errbotio";
    repo = "errbot";
    rev = version;
    hash = "sha256-UdqzBrlcb9NkuVo8ChADJmaKevadoGLyZUrckStb5ko=";
  };

  pythonRelaxDeps = true;

  propagatedBuildInputs = with python3.pkgs; [
    ansi
    colorlog
    daemonize
    deepmerge
    dulwich
    flask
    irc
    jinja2
    markdown
    pyasn1
    pyasn1-modules
    pygments
    pygments-markdown-lexer
    pyopenssl
    requests
    slixmpp
    python-telegram-bot
    webtest
  ];

  nativeCheckInputs = with python3.pkgs; [
    mock
    pytestCheckHook
  ];

  # errbot-backend-slackv3 has not been packaged
  pytestFlagsArray = [ "--ignore=tests/backend_tests/slack_test.py" ];

  disabledTests = [
    # require networking
    "test_backup"
    "test_broken_plugin"
    "test_plugin_cycle"
    "test_entrypoint_paths"
  ];

  pythonImportsCheck = [ "errbot" ];

  meta = with lib; {
    changelog = "https://github.com/errbotio/errbot/blob/${version}/CHANGES.rst";
    description = "Chatbot designed to be simple to extend with plugins written in Python";
    homepage = "http://errbot.io/";
    maintainers = [ ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    # flaky on darwin, "RuntimeError: can't start new thread"
    mainProgram = "errbot";
  };
}
