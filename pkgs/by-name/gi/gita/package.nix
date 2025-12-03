{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
}:

python3Packages.buildPythonApplication rec {
  version = "0.16.8.2";
  format = "setuptools";
  pname = "gita";

  src = fetchFromGitHub {
    sha256 = "sha256-JzfGj17YCYXmpGV2jSsGLsG1oqO5ynj7r3u/mkSBRBg=";
    rev = "v${version}";
    repo = "gita";
    owner = "nosarthur";
  };

  dependencies = with python3Packages; [
    argcomplete
    setuptools
  ];

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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ seqizz ];
    mainProgram = "gita";
  };
}
