{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libosmocore
, sqlite
, libosmoabis
, libosmo-netif
, libosmo-sccp
, osmo-mgw
, osmo-hlr
, lksctp-tools
}:

let
  inherit (stdenv.hostPlatform) isLinux;
in

stdenv.mkDerivation rec {
  pname = "osmo-msc";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-msc";
    rev = version;
    hash = "sha256-3yQKboodOBc55R6CdvqSFSwQpstvCVvtZMn7gFKASmI=";
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
    libosmo-sccp
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
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
