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
  version = "1.5.0-unstable-2025-03-16";

  src = fetchFromGitHub {
    owner = "freeDiameter";
    repo = "freeDiameter";
    rev = "8e525acdfd439995f3e8e26d5a802fc4ad95d24c";
    hash = "sha256-ai2R8scP++tdPh303RAl0qdIpehzFoyykAuAyl2w3MA=";
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
