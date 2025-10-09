{
  lib,
  stdenv,
  fetchurl,
  cctools,
  disablePosixThreads ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmcrypt";
  version = "2.5.8";

  src = fetchurl {
    url = "mirror://sourceforge/mcrypt/Libmcrypt/${finalAttrs.version}/libmcrypt-${finalAttrs.version}.tar.gz";
    hash = "sha256-5OtsB0u6sWisR7lHwZX/jO+dUaIRzdGMqcnvNNJ6Nz4=";
  };

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin cctools;

  configureFlags =
    lib.optionals disablePosixThreads [ "--disable-posix-threads" ]
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      # AC_FUNC_MALLOC is broken on cross builds.
      "ac_cv_func_malloc_0_nonnull=yes"
      "ac_cv_func_realloc_0_nonnull=yes"
    ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-implicit-function-declaration"
    "-Wno-implicit-int"
  ];

  meta = {
    description = "Replacement for the old crypt() package and crypt(1) command, with extensions";
    mainProgram = "libmcrypt-config";
    homepage = "https://mcrypt.sourceforge.net";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
  };
})
