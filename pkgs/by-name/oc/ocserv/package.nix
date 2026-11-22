{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  ipcalc,
  nettle,
  gnutls,
  libev,
  protobufc,
  guile,
  geoip,
  libseccomp,
  gperf,
  readline,
  lz4,
  ronn,
  pam,
  libxcrypt,
  oath-toolkit,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ocserv";
  version = "1.4.1";

  src = fetchFromGitLab {
    owner = "openconnect";
    repo = "ocserv";
    tag = finalAttrs.version;
    hash = "sha256-CaMUQd4J4g9gPWfJyUqO+IVFE1O3LjiODxFkDXSm9io=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gperf
    pkg-config
    ronn
  ];
  buildInputs = [
    ipcalc
    nettle
    gnutls
    libev
    protobufc
    guile
    geoip
    libseccomp
    readline
    lz4
    pam
    libxcrypt
    oath-toolkit
  ];

  meta = {
    homepage = "https://gitlab.com/openconnect/ocserv";
    license = lib.licenses.gpl2Plus;
    description = "OpenConnect VPN server (ocserv), a server for the OpenConnect VPN client";
    maintainers = with lib.maintainers; [ neverbehave ];
  };
})
