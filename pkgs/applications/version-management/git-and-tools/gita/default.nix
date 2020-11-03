{ lib
, buildPythonApplication
, fetchFromGitHub
, git
, pytest
, pyyaml
, setuptools
, installShellFiles
}:

buildPythonApplication rec {
  version = "0.10.10";
  pname = "gita";

  src = fetchFromGitHub {
    sha256 = "0k7hicncbrqvhmpq1w3v1309bqij6izw31xs8xcb8is85dvi754h";
    rev = "v${version}";
    repo = "gita";
    owner = "nosarthur";
  };

  requiredPythonModules = [
    pyyaml
    setuptools
  ];

  nativeBuildInputs = [ installShellFiles ];

  postUnpack = ''
    for case in "\n" ""; do
        substituteInPlace source/tests/test_main.py \
         --replace "'gita$case'" "'source$case'"
    done
  '';

  checkInputs = [
    git
    pytest
  ];

  checkPhase = ''
    git init
    pytest tests
  '';

  postInstall = ''
    installShellCompletion --bash --name gita ${src}/.gita-completion.bash
    installShellCompletion --zsh --name gita ${src}/.gita-completion.zsh
  '';

  meta = with lib; {
    description = "A command-line tool to manage multiple git repos";
    homepage = "https://github.com/nosarthur/gita";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
  };
}
