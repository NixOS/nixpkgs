{
  lib,
<<<<<<< HEAD
  git,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "gita";
  version = "0.16.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "gita";
    owner = "nosarthur";
    tag = "v${version}";
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
    "${src}/tests"
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
    changelog = "https://github.com/nosarthur/gita/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ seqizz ];
=======
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
}:

python3Packages.buildPythonApplication rec {
  version = "0.16.6.1";
  format = "setuptools";
  pname = "gita";

  src = fetchFromGitHub {
    sha256 = "sha256-kPyk13yd4rc63Nh73opuHsCTj4DgYAVfro8To96tteA=";
    rev = "v${version}";
    repo = "gita";
    owner = "nosarthur";
  };

  dependencies = with python3Packages; [
    pyyaml
    setuptools
  ];

  nativeBuildInputs = [ installShellFiles ];

  # 3 of the tests are failing
  doCheck = false;

  postInstall = ''
    installShellCompletion --bash --name gita ${src}/.gita-completion.bash
    installShellCompletion --zsh --name gita ${src}/.gita-completion.zsh
  '';

  meta = with lib; {
    description = "Command-line tool to manage multiple git repos";
    homepage = "https://github.com/nosarthur/gita";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "gita";
  };
}
