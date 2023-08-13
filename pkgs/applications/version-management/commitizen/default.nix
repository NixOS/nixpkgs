{ lib
, commitizen
, fetchFromGitHub
, git
, python3
, testers
}:

python3.pkgs.buildPythonApplication rec {
  pname = "commitizen";
  version = "3.5.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "commitizen-tools";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-4m3NCnGUX9lHCk6czwzxXLqf8GLi2u2A/crBZYTyplA=";
  };

  pythonRelaxDeps = [
    "decli"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
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
  ];

  nativeCheckInputs = with python3.pkgs; [
    argcomplete
    deprecated
    git
    py
    pytest-freezer
    pytest-mock
    pytest-regressions
    pytestCheckHook
  ];

  doCheck = true;

  # The tests require a functional git installation
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
    "test_bump_pre_commit_changelog_fails_always"
    "test_get_commits_with_signature"
    # fatal: not a git repository (or any of the parent directories): .git
    "test_commitizen_debug_excepthook"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = commitizen;
      command = "cz version";
    };
  };

  meta = with lib; {
    description = "Tool to create committing rules for projects, auto bump versions, and generate changelogs";
    homepage = "https://github.com/commitizen-tools/commitizen";
    changelog = "https://github.com/commitizen-tools/commitizen/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault anthonyroussel ];
  };
}
