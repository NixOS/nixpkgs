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
  version = "0.11.9";
  pname = "gita";

  src = fetchFromGitHub {
    sha256 = "9+zuLAx9lMfltsBqjvsivJ5wPnStPfq11XgGMv/JDpY=";
    rev = version;
    repo = "gita";
    owner = "nosarthur";
  };

  propagatedBuildInputs = [
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
