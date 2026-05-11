{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  json_c,
  openssl,
  check,
  file,
  help2man,
  which,
  gengetopt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libu2f-server";
  version = "1.1.0";
  src = fetchurl {
    url = "https://developers.yubico.com/libu2f-server/Releases/libu2f-server-${finalAttrs.version}.tar.xz";
    sha256 = "0xx296nmmqa57w0v5p2kasl5zr1ms2gh6qi4lhv6xvzbmjp3rkcd";
  };

  patches = [
    # remove after updating to next release
    (fetchpatch {
      name = "json-c-0.14-support.patch";
      url = "https://github.com/Yubico/libu2f-server/commit/f7c4983b31909299c47bf9b2627c84b6bfe225de.patch";
      sha256 = "10q66w3paii1yhfdmjskpip078fk9p3sjllbqx1yx71qbjki55b0";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    gengetopt
    help2man
    pkg-config
    which
  ];

  buildInputs = [
    json_c
    openssl
    check
    file
  ];

  meta = {
    homepage = "https://developers.yubico.com/libu2f-server/";
    description = "C library that implements the server-side of the U2F protocol";
    mainProgram = "u2f-server";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ philandstuff ];
  };
})
