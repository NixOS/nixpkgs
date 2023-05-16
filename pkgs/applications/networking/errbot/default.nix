{ lib
, fetchFromGitHub
<<<<<<< HEAD
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "errbot";
  version = "6.1.9";

  format = "setuptools";
=======
, glibcLocales
, python39
}:

let
  python3 = python39;
in python3.pkgs.buildPythonApplication rec {
  pname = "errbot";
  version = "6.1.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "errbotio";
    repo = "errbot";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-BmHChLWWnrtg0p4WH8bANwpo+p4RTwjYbXfyPnz6mp8=";
  };

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = true;
=======
    sha256 = "02h44qd3d91zy657hyqsw3gskgxg31848pw6zpb8dhd1x84z5y77";
  };

  LC_ALL = "en_US.utf8";

  buildInputs = [ glibcLocales ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = with python3.pkgs; [
    ansi
    colorlog
    daemonize
    deepmerge
    dulwich
    flask
<<<<<<< HEAD
=======
    hypchat
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    irc
    jinja2
    markdown
    pyasn1
    pyasn1-modules
    pygments
    pygments-markdown-lexer
    pyopenssl
    requests
<<<<<<< HEAD
    slixmpp
    python-telegram-bot
=======
    slackclient
    sleekxmpp
    telegram
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    webtest
  ];

  nativeCheckInputs = with python3.pkgs; [
    mock
    pytestCheckHook
  ];

<<<<<<< HEAD
  # errbot-backend-slackv3 has not been packaged
  pytestFlagsArray = [ "--ignore=tests/backend_tests/slack_test.py" ];

  disabledTests = [
    # require networking
    "test_backup"
    "test_broken_plugin"
    "test_plugin_cycle"
=======
  # Slack backend test has an import issue
  pytestFlagsArray = [ "--ignore=tests/backend_tests/slack_test.py" ];

  disabledTests = [
    "backup"
    "broken_plugin"
    "plugin_cycle"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [ "errbot" ];

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://github.com/errbotio/errbot/blob/${version}/CHANGES.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Chatbot designed to be simple to extend with plugins written in Python";
    homepage = "http://errbot.io/";
    maintainers = with maintainers; [ globin ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    # flaky on darwin, "RuntimeError: can't start new thread"
  };
}
