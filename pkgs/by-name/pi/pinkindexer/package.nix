{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  pkg-config,
  ninja,
  eigen,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "pinkindexer";
  version = "0-unstable-2026-08-27";

  src = fetchFromGitLab {
    domain = "gitlab.desy.de";
    owner = "thomas.white";
    repo = "pinkindexer";
    rev = "855ad0925eef2020ab1fb26b5dc2e83ccf5fd4a8";
    hash = "sha256-4lqEMn+EJwX24Y2NJ4Pijfamj1JwDHydyfYp+wS8Um0=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];
  buildInputs = [ eigen ];

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "PinkIndexer algorithm";
    homepage = "https://gitlab.desy.de/thomas.white/pinkindexer";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pmiddend ];
    platforms = lib.platforms.unix;
  };
}
