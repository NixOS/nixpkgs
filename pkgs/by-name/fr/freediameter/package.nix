{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  cmake,
  flex,
  pkg-config,
  gnutls,
  libgcrypt,
  libidn2,
  lksctp-tools,
  unstableGitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "freediameter";
  version = "1.6.0-unstable-2026-11-18";

  src = fetchFromGitHub {
    owner = "freeDiameter";
    repo = "freeDiameter";
    rev = "19e148d13b621cd33e0184ab14430f052c749817";
    hash = "sha256-ewaKzLioVxp358aGiG6zAPSij1C28fvBZWHdQYzmMRo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bison
    cmake
    flex
    pkg-config
  ];

  buildInputs = [
    gnutls
    libgcrypt
    libidn2
    lksctp-tools
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Implementation of the Diameter Protocol";
    homepage = "https://github.com/freeDiameter/freeDiameter";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    teams = with lib.teams; [ ngi ];
    maintainers = [ ];
  };
})
