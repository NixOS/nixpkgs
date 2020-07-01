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
  version = "0.10.9";
  pname = "gita";

  src = fetchFromGitHub {
    sha256 = "0wilyf4nnn2jyxrfqs8krya3zvhj6x36szsp9xhb6h08g1ihzp5i";
    rev = "v${version}";
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
  '';

  meta = with lib; {
    description = "A command-line tool to manage multiple git repos";
    homepage = "https://github.com/nosarthur/gita";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
  };
}
