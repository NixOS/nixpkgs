{ lib
, python3
, fetchFromGitHub
, glibcLocales
, libnotify
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zulip-term";
  version = "0.7.0";

  # no tests on PyPI
  src = fetchFromGitHub {
    owner = "zulip";
    repo = "zulip-terminal";
    rev = version;
    sha256 = "sha256-ZouUU4p1FSGMxPuzDo5P971R+rDXpBdJn2MqvkJO+Fw=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    lxml
    pygments
    pyperclip
    python-dateutil
    pytz
    typing-extensions
    tzlocal
    urwid
    urwid-readline
    zulip
  ];

  checkInputs = [
    glibcLocales
  ] ++ (with python3.pkgs; [
    pytestCheckHook
    pytest-cov
    pytest-mock
  ]);

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ libnotify ])
  ];

  disabledTests = [
    # IndexError: list index out of range
    "test_main_multiple_notify_options"
    "test_main_multiple_autohide_options"
  ];

  meta = with lib; {
    description = "Zulip's official terminal client";
    homepage = "https://github.com/zulip/zulip-terminal";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
