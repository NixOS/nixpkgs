{ buildPythonApplication
, charset-normalizer
, colorama
, commitizen
, decli
, fetchFromGitHub
, git
, jinja2
, lib
, packaging
, poetry-core
, py
, pytest-freezer
, pytest-mock
, pytest-regressions
, pytestCheckHook
, pyyaml
, questionary
, termcolor
, testers
, tomlkit
, typing-extensions
, argcomplete
, nix-update-script
, pre-commit
}:

buildPythonApplication rec {
  pname = "commitizen";
  version = "2.42.1";

  src = fetchFromGitHub {
    owner = "commitizen-tools";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lrZfMqmslwx3B2WkvFosm3EmCHgpZEA/fOzR6UYf6f8=";
  };

  format = "pyproject";

  nativeBuildInputs = [ poetry-core ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'charset-normalizer = "^2.1.0"' 'charset-normalizer = "*"' \
      --replace 'argcomplete = ">=1.12.1,<2.1"' 'argcomplete = ">=1.12.1"'
  '';

  propagatedBuildInputs = [
    charset-normalizer
    termcolor
    questionary
    colorama
    decli
    tomlkit
    jinja2
    pyyaml
    argcomplete
    typing-extensions
    packaging
  ];

  doCheck = true;

  nativeCheckInputs = [
    pre-commit
    py
    pytestCheckHook
    pytest-freezer
    pytest-mock
    pytest-regressions
    argcomplete
    git
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
