{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  libnfc,
  openssl,
}:

stdenv.mkDerivation {
  pname = "libfreefare";
  version = "0.4.0";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libfreefare/libfreefare-0.4.0.tar.bz2";
    hash = "sha256-v6MdFKmaEkf17UkZXWNz3lEuPrdb8WJ2WLQM9/h2vGQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libnfc
    openssl
  ];

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-function-declaration"
    ];
  };

  meta = {
    description = "Convenient API for MIFARE card manipulations";
    license = lib.licenses.lgpl3;
    homepage = "https://github.com/nfc-tools/libfreefare";
    maintainers = with lib.maintainers; [ bobvanderlinden ];
    platforms = lib.platforms.unix;
  };
}
