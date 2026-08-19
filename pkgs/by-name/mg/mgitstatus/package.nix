{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mgitstatus";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "fboender";
    repo = "multi-git-status";
    rev = finalAttrs.version;
    hash = "sha256-DToyP6TD9up0k2/skMW3el6hNvKD+c8q2zWpk0QZGRA=";
  };

  installFlags = [
    "PREFIX=$(out)"
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Show uncommitted, untracked and unpushed changes for multiple Git repos";
    downloadPage = "https://github.com/fboender/multi-git-status/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/fboender/multi-git-status";
    changelog = "https://github.com/fboender/multi-git-status/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getpsyched ];
    mainProgram = "mgitstatus";
    platforms = lib.platforms.all;
  };
})
