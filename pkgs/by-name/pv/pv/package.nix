{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pv";
  version = "1.9.7";

  src = fetchurl {
    url = "https://www.ivarch.com/programs/sources/pv-${finalAttrs.version}.tar.gz";
    hash = "sha256-aXanie4bvP3EdzIBW2BYnB0ECIkiUt18u0T0M2Oi8zo=";
  };

  meta = {
    homepage = "https://www.ivarch.com/programs/pv.shtml";
    description = "Tool for monitoring the progress of data through a pipeline";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    platforms = lib.platforms.all;
    mainProgram = "pv";
  };
})
