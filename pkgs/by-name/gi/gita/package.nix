{
  lib,
  git,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gita";
  version = "0.16.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "gita";
    owner = "nosarthur";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JzfGj17YCYXmpGV2jSsGLsG1oqO5ynj7r3u/mkSBRBg=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [ python3Packages.argcomplete ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    git
    python3Packages.pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  enabledTestPaths = [
    "${finalAttrs.src}/tests"
  ];

  disabledTests = [
    # This test fails as it tries to write to the Nix store.
    "test_set_first_time"
  ];

  # The test suite assumes that it is ran from a directory called "gita" that is
  # a git repository.
  preCheck = ''
    mkdir $TMPDIR/gita
    git init $TMPDIR/gita
    cd $TMPDIR/gita
  '';

  postInstall = ''
    installShellCompletion --bash --name gita auto-completion/bash/.gita-completion.bash
    installShellCompletion --fish --name gita auto-completion/fish/gita.fish
    installShellCompletion --zsh --name gita auto-completion/zsh/.gita-completion.zsh
  '';

  meta = {
    description = "Command-line tool to manage multiple git repos";
    homepage = "https://github.com/nosarthur/gita";
    changelog = "https://github.com/nosarthur/gita/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ seqizz ];
    mainProgram = "gita";
  };
})
