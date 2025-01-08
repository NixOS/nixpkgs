{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
  lksctp-tools,
  libosmo-netif,
  libosmo-sccp,
  libasn1c,
  python3,
}:

let
  inherit (stdenv.hostPlatform) isLinux;
in

stdenv.mkDerivation rec {
  pname = "osmo-iuh";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-iuh";
    rev = version;
    hash = "sha256-3ADn0GSoXPXL1gD79JjD2hXNBN/v8aaEKgf5qFNGEJs=";
  };

  prePatch = ''
    substituteInPlace src/../asn1/utils/asn1tostruct.py  \
      --replace '#!/usr/bin/env python3' '#!${python3}/bin/python3'
  '';

  postPatch = ''
    echo "${version}" > .tarball-version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
  ];

  buildInputs = [
    libosmocore
    lksctp-tools
    libosmo-netif
    libosmo-sccp
    libasn1c
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Osmocom IuH library";
    homepage = "https://osmocom.org/projects/osmohnbgw/wiki";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
