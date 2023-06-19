{ argcomplete
, buildPythonApplication
, charset-normalizer
, colorama
, commitizen
, decli
, deprecated
, fetchFromGitHub
, git
, importlib-metadata
, jinja2
, lib
, nix-update-script
, packaging
, poetry-core
, pre-commit
, py
, pytest-freezer
, pytest-mock
, pytest-regressions
, pytestCheckHook
, pythonRelaxDepsHook
, pyyaml
, questionary
, termcolor
, testers
, tomlkit
, typing-extensions
}:

buildPythonApplication rec {
  pname = "commitizen";
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "commitizen-tools";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4m3NCnGUX9lHCk6czwzxXLqf8GLi2u2A/crBZYTyplA=";
  };

  format = "pyproject";

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "decli"
  ];

  propagatedBuildInputs = [
    argcomplete
    charset-normalizer
    colorama
    decli
    importlib-metadata
    jinja2
    packaging
    pyyaml
    questionary
    termcolor
    tomlkit
    typing-extensions
  ];

  doCheck = true;

  nativeCheckInputs = [
    argcomplete
    deprecated
    git
    pre-commit
    py
    pytest-freezer
    pytest-mock
    pytest-regressions
    pytestCheckHook
  ];

  # the tests require a functional git installation
  # which requires a valid HOME directory.
  preCheck = ''
    export HOME="$(mktemp -d)"

    git config --global user.name "Nix Builder"
    git config --global user.email "nix-builder@nixos.org"
    git init .
  '';

  # NB: These tests require complex GnuPG setup
  disabledTests = [
    "test_bump_minor_increment_signed"
    "test_bump_minor_increment_signed_config_file"
    "test_bump_on_git_with_hooks_no_verify_enabled"
    "test_bump_on_git_with_hooks_no_verify_disabled"
    "test_bump_pre_commit_changelog"
    "test_get_commits_with_signature"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = commitizen;
      command = "cz version";
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Tool to create committing rules for projects, auto bump versions, and generate changelogs";
    homepage = "https://github.com/commitizen-tools/commitizen";
    changelog = "https://github.com/commitizen-tools/commitizen/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault anthonyroussel ];
  };
}
