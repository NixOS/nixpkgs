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
}:

stdenv.mkDerivation rec {
  pname = "ocserv";
  version = "1.3.0";

  src = fetchFromGitLab {
    owner = "openconnect";
    repo = "ocserv";
    rev = version;
    hash = "sha256-oZ1t1BTCdsq1jpa7LfzRGwQNTROHH9/lLBT2WAvj5h4=";
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
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/openconnect/ocserv";
    license = licenses.gpl2Plus;
    description = "OpenConnect VPN server (ocserv), a server for the OpenConnect VPN client";
    maintainers = with maintainers; [ neverbehave ];
  };
}
