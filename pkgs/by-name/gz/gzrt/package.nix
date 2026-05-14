{
  lib,
  stdenv,
  fetchurl,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gzrt";
  version = "0.8";

  src = fetchurl {
    url = "https://www.urbanophile.com/arenn/coding/gzrt/gzrt-${finalAttrs.version}.tar.gz";
    sha256 = "1vhzazj47xfpbfhzkwalz27cc0n5gazddmj3kynhk0yxv99xrdxh";
  };

  buildInputs = [ zlib ];

  installPhase = ''
    mkdir -p $out/bin
    cp gzrecover $out/bin
  '';

  meta = {
    homepage = "https://www.urbanophile.com/arenn/hacking/gzrt/";
    description = "Gzip Recovery Toolkit";
    maintainers = [ ];
    mainProgram = "gzrecover";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
