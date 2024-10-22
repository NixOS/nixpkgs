{
  lib,
  fetchFromGitHub,
  dooit,
  python311,
  testers,
  nix-update-script,
}:
let
  python3 = python311;
in
python3.pkgs.buildPythonApplication rec {
  pname = "dooit";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kraanzu";
    repo = "dooit";
    rev = "v${version}";
    hash = "sha256-GtXRzj+o+FClleh73kqelk0JrSyafZhf847lX1BiS9k=";
  };

  build-system = with python3.pkgs; [ poetry-core ];

  pythonRelaxDeps = [
    "tzlocal"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    pyperclip
    python-dateutil
    pyyaml
    (textual.overridePythonAttrs (oldAttrs: {
      version = "0.47.1";
      src = fetchFromGitHub {
        owner = "Textualize";
        repo = "textual";
        rev = "refs/tags/v0.47.1";
        hash = "sha256-RFaZKQ+0o6ZvfZxx95a1FjSHVJ0VOIAfzkdxYQXYBKU=";
      };
      disabledTests = [
        "test_tracked_slugs"
        "test_textual_env_var"
        "test_register_language"
        "test_register_language_existing_language"
      ];
    }))
    tzlocal
  ];

  # No tests available
  doCheck = false;

  passthru = {
    tests.version = testers.testVersion {
      package = dooit;
      command = "HOME=$(mktemp -d) dooit --version";
    };

    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "TUI todo manager";
    homepage = "https://github.com/kraanzu/dooit";
    changelog = "https://github.com/kraanzu/dooit/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      khaneliman
      wesleyjrz
      kraanzu
    ];
    mainProgram = "dooit";
  };
}
