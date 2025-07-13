{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libdaemon";
  version = "0.14";

  src = fetchurl {
    url = "https://0pointer.de/lennart/projects/libdaemon/${pname}-${version}.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  patches = [ ./fix-includes.patch ];

  configureFlags =
    [ "--disable-lynx" ]
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      # Can't run this test while cross-compiling
      "ac_cv_func_setpgrp_void=${if stdenv.hostPlatform.isBSD then "no" else "yes"}"
    ];

  meta = {
    description = "Lightweight C library that eases the writing of UNIX daemons";
    homepage = "http://0pointer.de/lennart/projects/libdaemon/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
}
