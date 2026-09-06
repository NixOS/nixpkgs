{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libpng,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pngnq";
  version = "1.1";

  src = fetchurl {
    url = "mirror://sourceforge/pngnq/pngnq-${finalAttrs.version}.tar.gz";
    sha256 = "1qmnnl846agg55i7h4vmrn11lgb8kg6gvs8byqz34bdkjh5gwiy1";
  };

  patches = [
    ./missing-includes.patch
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=incompatible-pointer-types"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libpng
    zlib
  ];

  meta = {
    homepage = "https://pngnq.sourceforge.net/";
    description = "PNG quantizer";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.linux;
  };
})
