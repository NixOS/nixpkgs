{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.5.1";
  pname = "libmpeg2";

  src = fetchurl {
    url = "http://libmpeg2.sourceforge.net/files/libmpeg2-${finalAttrs.version}.tar.gz";
    sha256 = "1m3i322n2fwgrvbs1yck7g5md1dbg22bhq5xdqmjpz5m7j4jxqny";
  };

  patches = [
    # Fixes mismatching definitions with C23 / GCC15 on non-glibc platforms
    ./getopt-getenv-signatures.patch
  ];

  # Otherwise clang fails with 'duplicate symbol ___sputc'
  buildFlags = lib.optional stdenv.hostPlatform.isDarwin "CFLAGS=-std=gnu89";

  meta = {
    homepage = "http://libmpeg2.sourceforge.net/";
    description = "Free library for decoding mpeg-2 and mpeg-1 video streams";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = with lib.platforms; unix;
  };
})
