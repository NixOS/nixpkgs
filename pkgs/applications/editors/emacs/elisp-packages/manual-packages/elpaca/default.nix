{
  melpaBuild,
  fetchFromGitHub,
  git,
  unstableGitUpdater,
  lib,
}:

melpaBuild {
  pname = "elpaca";
  version = "0.2.0-unstable-2026-10-31";

  src = fetchFromGitHub {
    owner = "progfolio";
    repo = "elpaca";
    rev = "c16559abef25f0210b36dc1c789d2632d1b39d7f";
    hash = "sha256-6IDhYtKGOnhHZ5D5hjxNFUXS5hcC/4Dhhygel+kniNs=";
  };

  nativeBuildInputs = [ git ];

  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  meta = {
    homepage = "https://github.com/progfolio/elpaca";
    description = "Elisp package manager";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      abhisheksingh0x558
    ];
  };
}
