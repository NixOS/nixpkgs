{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clzip";
  version = "1.13";

  src = fetchurl {
    url = "mirror://savannah/lzip/clzip/clzip-${finalAttrs.version}.tar.gz";
    hash = "sha256-esn79QNr9Q+wtqIOhNIpPLDSTUBE6vM8vpdgu55/6no=";
  };

  meta = with lib; {
    homepage = "https://www.nongnu.org/lzip/clzip.html";
    description = "C language version of lzip";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ rs0vere ];
    platforms = platforms.all;
  };
})
