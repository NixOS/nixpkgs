{
  lib,
  stdenv,

  src,
  version,

  autoreconfHook,
  pkg-config,

  cyrus_sasl,
  openssl,
  zlib,
}:
stdenv.mkDerivation {
  pname = "mailspring-libetpan";
  inherit src version;

  sourceRoot = "${src.name}/mailsync/Vendor/libetpan";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    cyrus_sasl
    openssl
    zlib
  ];

  configureFlags = [
    "--with-sasl=${cyrus_sasl.dev}"
    "--with-openssl=${openssl.dev}"
  ];

  # Prevent GCC 14 from treating pointer type mismatches as fatal build errors
  env.CFLAGS = toString [
    "-std=gnu17"
    "-Wno-error=incompatible-pointer-types"
  ];

  meta = {
    description = "Modified fork of the libetpan mail framework";
    homepage = "https://github.com/Foundry376/Mailspring-Sync";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
