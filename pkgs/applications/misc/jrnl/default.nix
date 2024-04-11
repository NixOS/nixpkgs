{ lib
, fetchFromGitHub
, python3
, testers
, jrnl
}:

python3.pkgs.buildPythonApplication rec {
  pname = "jrnl";
  version = "4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jrnl-org";
    repo = "jrnl";
    rev = "refs/tags/v${version}";
    hash = "sha256-DtujXSDJWnOrHjVgJEJNKJMhSrNBHlR2hvHeHLSIF2o=";
  };

  build-system = with python3.pkgs; [
    poetry-core
  ];

  dependencies = with python3.pkgs; [
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
    ruamel-yaml
    rich
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-bdd
    pytest-xdist
    pytestCheckHook
    toml
  ];


  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [
    "jrnl"
  ];

  passthru.tests.version = testers.testVersion {
    package = jrnl;
    version = "v${version}";
  };

  meta = with lib; {
    description = "Command line journal application that stores your journal in a plain text file";
    homepage = "https://jrnl.sh/";
    changelog = "https://github.com/jrnl-org/jrnl/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ bryanasdev000 zalakain ];
    mainProgram = "jrnl";
  };
}
