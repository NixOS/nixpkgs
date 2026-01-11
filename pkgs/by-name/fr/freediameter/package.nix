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
  version = "1.6.0-unstable-2025-10-18";

  src = fetchFromGitHub {
    owner = "freeDiameter";
    repo = "freeDiameter";
    rev = "9d4bc47584bfeced9de708fe00f5629ac4689db5";
    hash = "sha256-NHOsmRfdBXN59lGZAlDzwEqEkekZaux3shaGhP87Rdc=";
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
