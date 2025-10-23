{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  pytestCheckHook,
  git,
  testers,
  mu-repo,
}:

buildPythonApplication rec {
  pname = "mu-repo";
  version = "1.9.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fabioz";
    repo = "mu-repo";
    tag = "mu_repo_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-aSRf0B/skoZLsn4dykWOFKVNtHYCsD9RtZ1frHDrcJU=";
  };

  dependencies = [ git ];

  nativeCheckInputs = [
    pytestCheckHook
    git
  ];

  disabledTests = [ "test_action_diff" ];

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
