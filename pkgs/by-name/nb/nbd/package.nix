{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  which,
  bison,
  nixosTests,
  libnl,
  linuxHeaders,
  gnutls,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nbd";
  version = "3.27.0";

  src = fetchurl {
    url = "https://github.com/NetworkBlockDevice/nbd/releases/download/nbd-${finalAttrs.version}/nbd-${finalAttrs.version}.tar.xz";
    hash = "sha256-QioCrc26sBxiIwfGur7aXITKbG8tTgspk25q6banZi8=";
  };

  nativeBuildInputs = [
    pkg-config
    which
    bison
  ];

  buildInputs = [
    glib
    gnutls
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libnl
    linuxHeaders
  ];

  configureFlags = [
    "--sysconfdir=/etc"
  ];

  # ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=implicit-function-declaration";

  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru.tests = {
    test = nixosTests.nbd;
  };

  meta = {
    homepage = "https://nbd.sourceforge.io/";
    description = "Map arbitrary files as block devices over the network";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
