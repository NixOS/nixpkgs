{
  lib,
  fetchFromGitHub,
  python3,
  testers,
  jrnl,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "jrnl";
  version = "4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jrnl-org";
    repo = "jrnl";
    rev = "refs/tags/v${version}";
    hash = "sha256-x0JoYJzD6RnuHbRsQMgrhHsNW6nVEVeoDjtPop2eg+w=";
  };

  postPatch = ''
    # Support pytest_bdd 7.1.2 and later, https://github.com/jrnl-org/jrnl/pull/1878
    substituteInPlace tests/lib/when_steps.py \
      --replace-fail "from pytest_bdd.steps import inject_fixture" "from pytest_bdd.compat import inject_fixture"
  '';

  build-system = with python3.pkgs; [ poetry-core ];

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
    (pytestCheckHook.override { pytest = pytest_7; })
    toml
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [ "jrnl" ];

  passthru.tests.version = testers.testVersion {
    package = jrnl;
    version = "v${version}";
  };

  meta = with lib; {
    description = "Command line journal application that stores your journal in a plain text file";
    homepage = "https://jrnl.sh/";
    changelog = "https://github.com/jrnl-org/jrnl/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      bryanasdev000
      zalakain
    ];
    mainProgram = "jrnl";
  };
}
