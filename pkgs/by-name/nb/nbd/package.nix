{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  glib,
  which,
  bison,
  nixosTests,
  libnl,
  linuxHeaders,
  gnutls,
}:

stdenv.mkDerivation rec {
  pname = "nbd";
  version = "3.25";

  src = fetchurl {
    url = "https://github.com/NetworkBlockDevice/nbd/releases/download/nbd-${version}/nbd-${version}.tar.xz";
    hash = "sha256-9cj9D8tXsckmWU0OV/NWQy7ghni+8dQNCI8IMPDL3Qo=";
  };

  patches = [
    # fix port setting from nbdtab
    # https://github.com/NetworkBlockDevice/nbd/pull/154
    (fetchpatch {
      url = "https://github.com/NetworkBlockDevice/nbd/commit/915444bc0b8a931d32dfb755542f4bd1d37f1449.patch";
      hash = "sha256-6z+c2cXhY92WPDqRO6AJ5BBf1N38yTgOE1foduIr5Dg=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    which
    bison
  ];

  buildInputs =
    [
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
}
