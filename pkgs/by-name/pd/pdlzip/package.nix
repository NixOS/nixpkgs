{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdlzip";
  version = "1.12";

  src = fetchurl {
    url = "mirror://savannah/lzip/pdlzip/pdlzip-${finalAttrs.version}.tar.gz";
    hash = "sha256-RK1QS/Ji0KpAih73uydsRRt8EtSLCJ6e7XaAfbjU/BM=";
  };

  meta = with lib; {
    homepage = "https://www.nongnu.org/lzip/pdlzip.html";
    description = "Public-domain version of lzip compressor";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ rs0vere ];
    platforms = platforms.all;
  };
})
