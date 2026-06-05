{
  fetchurl,
  lib,
  stdenv,
  zlib,
  openssl,
  libuuid,
  pkg-config,
  bzip2,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "20231119";
  pname = "libewf";

  src = fetchurl {
    url = "https://github.com/libyal/libewf/releases/download/${finalAttrs.version}/libewf-experimental-${finalAttrs.version}.tar.gz";
    hash = "sha256-7AjUEaXasOzJV9ErZK2a4HMTaqhcBbLKd8M+A5SbKrc=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    zlib
    openssl
    libuuid
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ bzip2 ];

  # cannot run test program while cross compiling
  configureFlags = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "ac_cv_openssl_xts_duplicate_keys=yes"
  ];

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
  ];

  meta = {
    description = "Library for support of the Expert Witness Compression Format";
    homepage = "https://sourceforge.net/projects/libewf/";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
  };
})
