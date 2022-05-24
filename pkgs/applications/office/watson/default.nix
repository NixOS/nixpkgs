{ lib, fetchFromGitHub, python3, installShellFiles }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "watson";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "TailorDev";
    repo = "Watson";
    rev = version;
    sha256 = "sha256-/AASYeMkt18KPJljAjNPRYOpg/T5xuM10LJq4LrFD0g=";
  };

  postInstall = ''
    installShellCompletion --bash --name watson watson.completion
    installShellCompletion --zsh --name _watson watson.zsh-completion
    installShellCompletion --fish watson.fish
  '';

  checkInputs = [ pytestCheckHook pytest-mock mock pytest-datafiles ];
  propagatedBuildInputs = [ arrow click click-didyoumean requests ];
  nativeBuildInputs = [ installShellFiles ];

  meta = with lib; {
    homepage = "https://tailordev.github.io/Watson/";
    description = "A wonderful CLI to track your time!";
    license = licenses.mit;
    maintainers = with maintainers; [ mguentner nathyong oxzi ];
  };
}
