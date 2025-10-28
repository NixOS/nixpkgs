{
  melpaBuild,
  fetchFromGitHub,
  git,
  unstableGitUpdater,
  lib,
}:

melpaBuild {
  pname = "straight";
  version = "0-unstable-2025-01-30";

  src = fetchFromGitHub {
    owner = "radian-software";
    repo = "straight.el";
    rev = "44a866f28f3ded6bcd8bc79ddc73b8b5044de835";
    hash = "sha256-riKagjhCn5NyTerw1WqGOn37TZNfmhPb7DS49TXw1CA=";
  };

  nativeBuildInputs = [ git ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/radian-software/straight.el";
    description = "Next-generation, purely functional package manager for the Emacs hacker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ abhisheksingh0x558 ];
  };
}
