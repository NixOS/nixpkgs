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

stdenv.mkDerivation rec {
  pname = "osmo-msc";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-msc";
    rev = version;
    hash = "sha256-+Z49TqXLEeCy7Yj0qVg1hPFOD/x+4HnwDZxZoxoUjqI=";
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
    description = "Osmocom implementation of 3GPP Mobile Swtiching Centre (MSC)";
    mainProgram = "osmo-msc";
    homepage = "https://osmocom.org/projects/osmomsc/wiki";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux;
  };
}
