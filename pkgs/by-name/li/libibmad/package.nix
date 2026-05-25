{
  lib,
  stdenv,
  fetchurl,
  libibumad,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libibmad";
  version = "1.3.13";

  src = fetchurl {
    url = "https://www.openfabrics.org/downloads/management/libibmad-${finalAttrs.version}.tar.gz";
    sha256 = "02sj8k2jpcbiq8s0l2lqk4vwji2dbb2lc730cv1yzv0zr0hxgk8p";
  };

  buildInputs = [ libibumad ];

  meta = {
    homepage = "https://www.openfabrics.org/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
