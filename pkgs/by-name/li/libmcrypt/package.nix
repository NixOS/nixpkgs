{
  lib,
  stdenv,
  fetchurl,
  cctools,
  disablePosixThreads ? false,
}:

stdenv.mkDerivation rec {
  pname = "libmcrypt";
  version = "2.5.8";

  src = fetchurl {
    url = "mirror://sourceforge/mcrypt/Libmcrypt/${version}/libmcrypt-${version}.tar.gz";
    sha256 = "0gipgb939vy9m66d3k8il98rvvwczyaw2ixr8yn6icds9c3nrsz4";
  };

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin cctools;

  configureFlags =
    lib.optionals disablePosixThreads [ "--disable-posix-threads" ]
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      # AC_FUNC_MALLOC is broken on cross builds.
      "ac_cv_func_malloc_0_nonnull=yes"
      "ac_cv_func_realloc_0_nonnull=yes"
    ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration -Wno-implicit-int";
  };

  meta = {
    description = "Replacement for the old crypt() package and crypt(1) command, with extensions";
    mainProgram = "libmcrypt-config";
    homepage = "https://mcrypt.sourceforge.net";
    license = "GPL";
    platforms = lib.platforms.all;
  };
}
