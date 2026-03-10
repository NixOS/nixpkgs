{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libibumad";
  version = "1.3.10.2";

  src = fetchurl {
    url = "https://www.openfabrics.org/downloads/management/libibumad-${finalAttrs.version}.tar.gz";
    sha256 = "0bkygb3lbpaj6s4vsyixybrrkcnilbijv4ga5p1xdwyr3gip83sh";
  };

  meta = {
    homepage = "https://www.openfabrics.org/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
