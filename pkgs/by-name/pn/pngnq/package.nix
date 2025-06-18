{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libpng,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "pngnq";
  version = "1.1";

  src = fetchurl {
    url = "mirror://sourceforge/pngnq/pngnq-${version}.tar.gz";
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

  meta = with lib; {
    homepage = "https://pngnq.sourceforge.net/";
    description = "PNG quantizer";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
