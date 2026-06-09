{
  lib,
  stdenv,
  fetchurl,
  expat,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rnv";
  version = "1.7.11";

  src = fetchurl {
    url = "mirror://sourceforge/rnv/rnv-${finalAttrs.version}.tar.xz";
    sha256 = "1rlxrkkkp8b5j6lyvnd9z1d85grmwwmdggkxq6yl226nwkqj1faa";
  };

  buildInputs = [ expat ];

  meta = {
    description = "Relax NG Compact Syntax validator";
    homepage = "http://www.davidashen.net/rnv.html";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
