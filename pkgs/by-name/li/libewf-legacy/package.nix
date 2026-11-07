{
  lib,
  fetchurl,
  stdenv,
  zlib,
  openssl,
  libuuid,
  pkg-config,
  bzip2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libewf-legacy";
  version = "20140817";

  src = fetchurl {
    url = "https://github.com/libyal/libewf-legacy/releases/download/${finalAttrs.version}/libewf-${finalAttrs.version}.tar.gz";
    hash = "sha256-bbvv5o6RMkPcAAudqvWfKT4zwjQAJPffsUTxrZCwZUQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    zlib
    openssl
    libuuid
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ bzip2 ];

  meta = {
    description = "Legacy library for support of the Expert Witness Compression Format";
    homepage = "https://sourceforge.net/projects/libewf/";
    license = lib.licenses.lgpl3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
