{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mgitstatus";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "fboender";
    repo = "multi-git-status";
    rev = finalAttrs.version;
    hash = "sha256-jzoX7Efq9+1UdXQdhLRqBlhU3cBrk5AZblg9AYetItg=";
  };

  installFlags = [
    "PREFIX=$(out)"
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = "v${finalAttrs.version}";
  };

  meta = with lib; {
    description = "Show uncommitted, untracked and unpushed changes for multiple Git repos";
    downloadPage = "https://github.com/fboender/multi-git-status/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/fboender/multi-git-status";
    license = licenses.mit;
    maintainers = with maintainers; [ getpsyched ];
    mainProgram = "mgitstatus";
    platforms = platforms.all;
  };
})
