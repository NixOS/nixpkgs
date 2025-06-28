{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  endlessh,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "endlessh";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "endlessh";
    rev = version;
    hash = "sha256-yHQzDrjZycDL/2oSQCJjxbZQJ30FoixVG1dnFyTKPH4=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.tests = {
    inherit (nixosTests) endlessh;
    version = testers.testVersion {
      package = endlessh;
      command = "endlessh -V";
    };
  };

  meta = {
    description = "SSH tarpit that slowly sends an endless banner";
    homepage = "https://github.com/skeeto/endlessh";
    changelog = "https://github.com/skeeto/endlessh/releases/tag/${version}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ azahi ];
    platforms = lib.platforms.unix;
    mainProgram = "endlessh";
  };
}
