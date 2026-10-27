{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  gnutls,
  p11-kit,
  openssl,
  useOpenSSL ? false,
  gmp,
  libxml2,
  stoken,
  zlib,
  pcsclite,
  vpnc-scripts,
  useDefaultExternalBrowser ?
    stdenv.hostPlatform.isLinux && stdenv.buildPlatform == stdenv.hostPlatform, # xdg-utils doesn't cross-compile
  xdg-utils,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "openconnect";
  version = "9.12-unstable-2025-11-03";

  src = fetchFromGitLab {
    owner = "openconnect";
    repo = "openconnect";
    rev = "0dcdff87db65daf692dc323732831391d595d98d";
    hash = "sha256-AvowUEDkXvR+QkhJbZU759fZjIqj/mO8HjP2Ka3lH1U=";
  };

  outputs = [
    "out"
    "dev"
  ];

  configureFlags = [
    "--with-vpnc-script=${vpnc-scripts}/bin/vpnc-script"
    "--disable-nls"
    "--without-openssl-version-check"
  ];

  # Not finding iconv on Darwin
  env = {
    am_cv_func_iconv_works = "yes";
  };

  buildInputs = [
    gmp
    libxml2
    stoken
    zlib
    (if useOpenSSL then openssl else gnutls)
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    p11-kit
    pcsclite
  ]
  ++ lib.optional useDefaultExternalBrowser xdg-utils;
  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  meta = {
    description = "VPN Client for Cisco's AnyConnect SSL VPN";
    homepage = "https://www.infradead.org/openconnect/";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [
      tricktron
      pentane
    ];
    platforms = lib.platforms.unix;
    mainProgram = "openconnect";
  };
}
