{ lib
, python3
, fetchFromGitHub
, glibcLocales
, libnotify
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zulip-term";
  version = "0.6.0";

  # no tests on PyPI
  src = fetchFromGitHub {
    owner = "zulip";
    repo = "zulip-terminal";
    rev = version;
    sha256 = "sha256-nlvZaGMVRRCu8PZHxPWjNSxkqhZs0T/tE1js/3pDUFk=";
  };

  patches = [
    ./pytest-executable-name.patch
  ];

  propagatedBuildInputs = with python3.pkgs; [
    urwid
    zulip
    urwid-readline
    beautifulsoup4
    lxml
    typing-extensions
    python-dateutil
    tzlocal
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

  meta = with lib; {
    description = "Zulip's official terminal client";
    homepage = "https://github.com/zulip/zulip-terminal";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
