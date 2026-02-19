{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sipcalc";
  version = "1.1.6";

  src = fetchurl {
    url = "http://www.routemeister.net/projects/sipcalc/files/sipcalc-${finalAttrs.version}.tar.gz";
    sha256 = "cfd476c667f7a119e49eb5fe8adcfb9d2339bc2e0d4d01a1d64b7c229be56357";
  };

  meta = {
    description = "Advanced console ip subnet calculator";
    homepage = "http://www.routemeister.net/projects/sipcalc/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.globin ];
    mainProgram = "sipcalc";
  };
})
