{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libevent,
  libressl,
  readline,
  libbsd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kamid";
  version = "0.2";

  src = fetchurl {
    url = "https://github.com/omar-polo/kamid/releases/download/${finalAttrs.version}/kamid-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-23LgcZ+R6wcUz1fZA+IbhyshfQOTyiFPZ+uKVwOh680=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libevent
    libressl
    readline
    libbsd
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # client.c:381:13: error: implicit declaration of function 'setgroups'; did you mean 'getgroups'?
    "-Wno-error=implicit-function-declaration"
    # ftp.c:1585:22: error: passing argument 1 of 'log_procinit' makes pointer from integer without a cast
    "-Wno-error=int-conversion"
  ];

  makeFlags = [ "AR:=$(AR)" ];

  meta = {
    description = "FREE, easy-to-use and portable implementation of a 9p file server daemon for UNIX-like systems";
    homepage = "https://kamid.omarpolo.com";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ heph2 ];
    platforms = lib.platforms.linux;
  };
})
