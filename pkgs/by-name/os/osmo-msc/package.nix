{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
  sqlite,
  libosmoabis,
  libosmo-netif,
  libosmo-sigtran,
  osmo-mgw,
  osmo-hlr,
  lksctp-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osmo-msc";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-msc";
    rev = finalAttrs.version;
    hash = "sha256-xooUBH0nCCD2szRa3O7U2n2uRv8+y40ON50LMb0jqkU=";
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
    sqlite
    libosmoabis
    libosmo-netif
    libosmo-sigtran
    osmo-mgw
    osmo-hlr
    lksctp-tools
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom implementation of 3GPP Mobile Switching Centre (MSC)";
    mainProgram = "osmo-msc";
    homepage = "https://osmocom.org/projects/osmomsc/wiki";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux;
  };
})
