{
  lib,
  fetchFromGitHub,
  gitMinimal,
  stdenv,
  installShellFiles,
  nix-update-script,
  python3Packages,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonPackage rec {
  pname = "commitizen";
  version = "4.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "commitizen-tools";
    repo = "commitizen";
    tag = "v${version}";
    hash = "sha256-4hsKCBJHeRjc519h7KO/X8BJhGuw0N6XmC6u+QEiAnc=";
  };

  pythonRelaxDeps = [
    "argcomplete"
    "decli"
    "termcolor"
  ];

  build-system = with python3Packages; [ poetry-core ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies = with python3Packages; [
    argcomplete
    charset-normalizer
    colorama
    decli
    deprecated
    importlib-metadata
    jinja2
    packaging
    pyyaml
    questionary
    termcolor
    tomlkit
  ];

  nativeCheckInputs = [
    gitMinimal
    versionCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ (with python3Packages; [
    argcomplete
    py
    pytest-freezer
    pytest-mock
    pytest-regressions
    pytest7CheckHook
  ]);

  versionCheckProgramArg = "version";

  pythonImportsCheck = [ "commitizen" ];

  # The tests require a functional git installation
  preCheck = ''
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
      register-python-argcomplete = lib.getExe' python3Packages.argcomplete "register-python-argcomplete";
    in
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd cz \
        --bash <(${register-python-argcomplete} --shell bash $out/bin/cz) \
        --zsh <(${register-python-argcomplete} --shell zsh $out/bin/cz) \
        --fish <(${register-python-argcomplete} --shell fish $out/bin/cz)
    '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to create committing rules for projects, auto bump versions, and generate changelogs";
    homepage = "https://github.com/commitizen-tools/commitizen";
    changelog = "https://github.com/commitizen-tools/commitizen/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "cz";
    maintainers = with lib.maintainers; [
      lovesegfault
      anthonyroussel
    ];
  };
}
