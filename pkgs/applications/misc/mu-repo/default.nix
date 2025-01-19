{
  lib,
  fetchFromGitHub,
  buildPythonApplication,
  pytestCheckHook,
  git,
  testers,
  mu-repo,
}:

buildPythonApplication rec {
  pname = "mu-repo";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "fabioz";
    repo = "mu-repo";
    rev = "mu_repo_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-COc7hbu72eA+ikZQkz6zXtFyaa/AKhoF+Zvsr6ZVOuY=";
  };

  propagatedBuildInputs = [ git ];

  nativeCheckInputs = [
    pytestCheckHook
    git
  ];

  passthru.tests.version = testers.testVersion {
    package = mu-repo;
  };

  meta = {
    description = "Tool to help in dealing with multiple git repositories";
    homepage = "http://fabioz.github.io/mu-repo/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sikmir ];
    mainProgram = "mu";
  };
}
