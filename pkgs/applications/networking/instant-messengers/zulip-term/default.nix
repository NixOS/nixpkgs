{ lib
, python3
, fetchFromGitHub
, glibcLocales
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zulip-term";
  version = "0.5.2";

  # no tests on PyPI
  src = fetchFromGitHub {
    owner = "zulip";
    repo = "zulip-terminal";
    rev = version;
    sha256 = "1xhhy3v4wck74a83avil0rnmsi2grrh03cww19n5mv80p2q1cjmf";
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
    mypy-extensions
  ];

  checkInputs = [
    glibcLocales
  ] ++ (with python3.pkgs; [
    pytestCheckHook
    pytestcov
    pytest-mock
  ]);

  meta = with lib; {
    description = "Zulip's official terminal client";
    homepage = "https://github.com/zulip/zulip-terminal";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
