{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libasyncns";
  version = "0.8";

  src = fetchurl {
    url = "https://0pointer.de/lennart/projects/libasyncns/${pname}-${version}.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace libasyncns/asyncns.c \
      --replace '<arpa/nameser.h>' '<arpa/nameser_compat.h>'
  '';

  configureFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  meta = with lib; {
    homepage = "http://0pointer.de/lennart/projects/libasyncns/";
    description = "C library for Linux/Unix for executing name service queries asynchronously";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
