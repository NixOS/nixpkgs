{ lib
, fetchFromGitHub
, fetchpatch
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "jrnl";
  version = "2.8.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jrnl-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+kPr7ndY6u1HMw6m0UZJ5jxVIPNjlTfQt7OYEdZkHBE=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    ansiwrap
    asteval
    colorama
    cryptography
    keyring
    parsedatetime
    python-dateutil
    pytz
    pyxdg
    pyyaml
    tzlocal
  ];

  checkInputs = with python3.pkgs; [
    pytest-bdd
    pytestCheckHook
    toml
  ];

  patches = [
    # Switch to poetry-core, https://github.com/jrnl-org/jrnl/pull/1359
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/jrnl-org/jrnl/commit/a55a240eff7a167af5974a03e9de6f7b818eafd9.patch";
      sha256 = "1w3gb4vasvh51nggf89fsqsm4862m0g7hr36qz22n4vg9dds175m";
    })
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [
    "jrnl"
  ];

  meta = with lib; {
    description = "Simple command line journal application that stores your journal in a plain text file";
    homepage = "https://jrnl.sh/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zalakain ];
  };
}
