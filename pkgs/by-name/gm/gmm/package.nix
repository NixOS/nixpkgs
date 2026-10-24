{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gmm";
  version = "5.5";

  src = fetchurl {
    url = "mirror://savannah/getfem/stable/gmm-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-SaXoHP+JuHEZB1YI2V2TfcAnGmKDnm1N/E1SOPXAAQI=";
  };

  meta = {
    description = "Generic C++ template library for sparse, dense and skyline matrices";
    homepage = "http://getfem.org/gmm.html";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
