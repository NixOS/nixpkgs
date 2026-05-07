{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
  libosmoabis,
  libosmo-netif,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osmo-bts";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-bts";
    rev = finalAttrs.version;
    hash = "sha256-eqra1dh84c3mv4ISqrwe7dbhlawWNGvuYd1CDLAfwNk=";
  };

  postPatch = ''
    echo "${finalAttrs.version}" > .tarball-version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libosmocore
    libosmoabis
    libosmo-netif
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom GSM Base Transceiver Station (BTS)";
    homepage = "https://osmocom.org/projects/osmobts";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux;
  };
})
