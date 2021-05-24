{ lib, fetchFromGitHub, pythonPackages, installShellFiles }:

with pythonPackages;

buildPythonApplication rec {
  pname = "watson";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "TailorDev";
    repo = "Watson";
    rev = version;
    sha256 = "0radf5afyphmzphfqb4kkixahds2559nr3yaqvni4xrisdaiaymz";
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
