{ stdenv, fetchFromGitHub, pythonPackages, installShellFiles }:

with pythonPackages;

buildPythonApplication rec {
  pname = "watson";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "TailorDev";
    repo = "Watson";
    rev = version;
    sha256 = "1s0k86ldqky6avwjaxkw1y02wyf59qwqldcahy3lhjn1b5dgsb3s";
  };

  checkPhase = ''
    pytest -vs tests
  '';

  postInstall = ''
    installShellCompletion --bash --name watson watson.completion
    installShellCompletion --zsh --name _watson watson.zsh-completion
  '';

  checkInputs = [ py pytest pytest-datafiles pytest-mock pytestrunner ];
  propagatedBuildInputs = [ arrow click click-didyoumean requests ];
  nativeBuildInputs = [ installShellFiles ];

  meta = with stdenv.lib; {
    homepage = "https://tailordev.github.io/Watson/";
    description = "A wonderful CLI to track your time!";
    license = licenses.mit;
    maintainers = with maintainers; [ mguentner nathyong geistesk ];
  };
}
