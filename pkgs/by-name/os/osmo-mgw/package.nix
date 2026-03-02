{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
  libosmo-netif,
  libosmoabis,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osmo-mgw";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-mgw";
    rev = finalAttrs.version;
    hash = "sha256-Y/98K81US6McNu+JEJtMluJTvsv0DHJiyjMPJz8/35o=";
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
    libosmo-netif
    libosmoabis
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom Media Gateway (MGW). speaks RTP and E1 as well as MGCP";
    mainProgram = "osmo-mgw";
    homepage = "https://osmocom.org/projects/osmo-mgw";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux;
  };
})
