{ lib
, python3
, fetchFromGitHub
, glibcLocales
, libnotify
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zulip-term";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zulip";
    repo = "zulip-terminal";
    rev = "refs/tags/${version}";
    hash = "sha256-ZouUU4p1FSGMxPuzDo5P971R+rDXpBdJn2MqvkJO+Fw=";
  };

  patches = [
    ./pytest-executable-name.patch
  ];

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

  nativeCheckInputs = [
    glibcLocales
  ] ++ (with python3.pkgs; [
    pytestCheckHook
    pytest-cov
    pytest-mock
  ]);

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ libnotify ])
  ];

  meta = with lib; {
    description = "Zulip's official terminal client";
    homepage = "https://github.com/zulip/zulip-terminal";
    changelog = "https://github.com/zulip/zulip-terminal/releases/tag/0.7.0";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
