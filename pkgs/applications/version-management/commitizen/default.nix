{ lib
, commitizen
, fetchFromGitHub
, git
, python3
, stdenv
, installShellFiles
, nix-update-script
, testers
}:

python3.pkgs.buildPythonApplication rec {
  pname = "commitizen";
  version = "3.13.0";
  format = "pyproject";

  disabled = python3.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "commitizen-tools";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-6Zo+d1OuaHYVf/KX8hKlyp/YS/1tHFmpNK6ssnxg7h0=";
  };

  pythonRelaxDeps = [
    "decli"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
    installShellFiles
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

  postInstall =
    let
      argcomplete = lib.getExe' python3.pkgs.argcomplete "register-python-argcomplete";
    in
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform)
      ''
        installShellCompletion --cmd cz \
          --bash <(${argcomplete} --shell bash $out/bin/cz) \
          --zsh <(${argcomplete} --shell zsh $out/bin/cz) \
          --fish <(${argcomplete} --shell fish $out/bin/cz)
      '';

  passthru = {
    updateScript = nix-update-script { };
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
    mainProgram = "cz";
    maintainers = with maintainers; [ lovesegfault anthonyroussel ];
  };
}
