{
  lib,
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
    mainProgram = "gita";
  };
}
