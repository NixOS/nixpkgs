{ lib, fetchFromGitHub, pythonPackages, installShellFiles }:

with pythonPackages;

buildPythonApplication rec {
  pname = "watson";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "TailorDev";
    repo = "Watson";
    rev = version;
    sha256 = "1yxqjirv7cpg4hqj4l3a53p3p3kl82bcx6drgvl9v849vcc3l7s0";
  };

  postInstall = ''
    installShellCompletion --bash --name watson watson.completion
    installShellCompletion --zsh --name _watson watson.zsh-completion
  '';

  checkInputs = [ pytestCheckHook pytest-mock mock pytest-datafiles ];
  propagatedBuildInputs = [ arrow_1 click click-didyoumean requests ];
  nativeBuildInputs = [ installShellFiles ];

  meta = with lib; {
    homepage = "https://tailordev.github.io/Watson/";
    description = "A wonderful CLI to track your time!";
    license = licenses.mit;
    maintainers = with maintainers; [ mguentner nathyong oxzi ];
  };
}
