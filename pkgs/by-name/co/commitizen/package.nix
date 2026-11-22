{
  lib,
  python3Packages,
  fetchFromGitHub,
  gitMinimal,
  stdenv,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "commitizen";
  version = "4.19.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "commitizen-tools";
    repo = "commitizen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ab94id1in6CPturJgqzUO6RTlvcKoL5bLxKrxqI2LKg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build >= 0.9.17, < 0.14" "uv-build"
  '';

  build-system = with python3Packages; [ uv-build ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies = with python3Packages; [
    argcomplete
    charset-normalizer
    colorama
    decli
    deprecated
    jinja2
    packaging
    prompt-toolkit
    pyyaml
    questionary
    termcolor
    tomlkit
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ gitMinimal ])
  ];

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ]
  ++ (with python3Packages; [
    argcomplete
    pytest-freezer
    pytest-gitconfig
    pytest-mock
    pytest-regressions
    pytest-xdist
    pytestCheckHook
  ]);

  pythonImportsCheck = [ "commitizen" ];

  # The tests require a functional git installation
  preCheck = ''
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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to create committing rules for projects, auto bump versions, and generate changelogs";
    homepage = "https://github.com/commitizen-tools/commitizen";
    changelog = "https://github.com/commitizen-tools/commitizen/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "cz";
    maintainers = with lib.maintainers; [
      lovesegfault
      anthonyroussel
    ];
  };
})
