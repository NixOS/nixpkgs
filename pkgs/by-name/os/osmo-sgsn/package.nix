{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
  libosmoabis,
  libosmo-netif,
  osmo-hlr,
  osmo-ggsn,
  c-ares,
}:

stdenv.mkDerivation rec {
  pname = "osmo-sgsn";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-sgsn";
    rev = version;
    hash = "sha256-tcGnsLsVJohxaSfMbGfkHcBhLpbTZbXM+KWe2j34qeo=";
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
    osmo-hlr
    osmo-ggsn
    c-ares
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom implementation of the 3GPP Serving GPRS Support Node (SGSN)";
    homepage = "https://osmocom.org/projects/osmosgsn";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux;
    mainProgram = "osmo-sgsn";
  };
}
