{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
  sofia_sip,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osmo-sip-connector";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-sip-connector";
    rev = finalAttrs.version;
    hash = "sha256-JOTUa1buj9qR8dnMZMLaxjSIrsLnr9g1yylkTgPcL4k=";
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
    sofia_sip
    glib
  ];

  enableParallelBuilding = true;

  meta = {
    description = "This implements an interface between the MNCC (Mobile Network Call Control) interface of OsmoMSC (and also previously OsmoNITB) and SIP";
    mainProgram = "osmo-sip-connector";
    homepage = "https://osmocom.org/projects/osmo-sip-conector";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux;
  };
})
