{
  lib,
  stdenv,
  fetchurl,
  zlib,
  openssl,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.49.2";
  pname = "httrack";

  src = fetchurl {
    url = "https://mirror.httrack.com/httrack-${finalAttrs.version}.tar.gz";
    sha256 = "09a0gm67nml86qby1k1gh7rdxamnrnzwr6l9r5iiq94favjs0xrl";
  };

  buildInputs = [
    libiconv
    openssl
    zlib
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Easy-to-use offline browser / website mirroring utility";
    homepage = "http://www.httrack.com";
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; unix;
  };
})
