{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lcab";
  version = "1.0b12";

  src = fetchurl {
    # Original site is no longer available
    url = "http://deb.debian.org/debian/pool/main/l/lcab/lcab_${finalAttrs.version}.orig.tar.gz";
    hash = "sha256-Bl8sF5O2XyhHHA9xt88SCnBk8o0cRLB8q/SewOl/H8g=";
  };

  patches = [
    # Fix version number
    (fetchurl {
      url = "https://salsa.debian.org/debian/lcab/-/raw/f72d6db6504123bd124b1a4be21ead8cc1535c9e/debian/patches/20-version.patch";
      hash = "sha256-Yb6E8nQVdicmjcGnxR7HHdsd7D+ThXk02UHiaB+PLvE=";
    })
  ];

  meta = with lib; {
    description = "Create cabinet (.cab) archives";
    homepage = "http://ohnopub.net/~ohnobinki/lcab";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
    mainProgram = "lcab";
  };
})
