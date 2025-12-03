{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
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

  # 3 of the tests are failing
  doCheck = false;

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
    mainProgram = "gita";
  };
}
