{
  lib,
  fetchFromGitHub,
  dooit,
  python3,
  testers,
  nix-update-script,
  extraPackages ? [ ],
}:
python3.pkgs.buildPythonApplication rec {
  pname = "dooit";
  version = "3.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dooit-org";
    repo = "dooit";
    tag = "v${version}";
    hash = "sha256-MWdih+j7spUVEWXCBzF2J/FVXK0TQ8VhrJNDhNfxpQE=";
  };

  build-system = with python3.pkgs; [ poetry-core ];

  pythonRelaxDeps = [
    "tzlocal"
    "textual"
    "sqlalchemy"
  ];

  propagatedBuildInputs =
    with python3.pkgs;
    [
      pyperclip
      textual
      pyyaml
      python-dateutil
      sqlalchemy
      platformdirs
      tzlocal
      click
    ]
    ++ extraPackages;

  # /homeless-shelter
  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    faker
    pytest-asyncio
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = dooit;
      command = "HOME=$(mktemp -d) dooit --version";
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "TUI todo manager";
    homepage = "https://github.com/dooit-org/dooit";
    changelog = "https://github.com/dooit-org/dooit/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      khaneliman
      wesleyjrz
      kraanzu
    ];
    mainProgram = "dooit";
  };
}
