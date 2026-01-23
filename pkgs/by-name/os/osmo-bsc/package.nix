{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
  libosmoabis,
  libosmo-netif,
  libosmo-sigtran,
  osmo-mgw,
}:

stdenv.mkDerivation rec {
  pname = "osmo-bsc";
  version = "1.13.3";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-bsc";
    rev = version;
    hash = "sha256-2Go+93h1Z4FV9sESfjwCaee1m4jUq2eO8fxlZAwZVfM=";
  };

  postPatch = ''
    echo "${version}" > .tarball-version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libosmocore
    libosmoabis
    libosmo-netif
    libosmo-sigtran
    osmo-mgw
  ];

  enableParallelBuilding = true;

  meta = {
    description = "GSM Base Station Controller";
    homepage = "https://projects.osmocom.org/projects/osmobsc";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux;
    mainProgram = "osmo-bsc";
  };
}
