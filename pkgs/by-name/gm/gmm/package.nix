{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gmm";
  version = "5.6";

  src = fetchurl {
    url = "mirror://savannah/getfem/stable/gmm-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-k5f8HF3E1Su72vamu3jmPmcq190kGUB0nDxXON44Yas=";
  };

  meta = {
    description = "Generic C++ template library for sparse, dense and skyline matrices";
    homepage = "http://getfem.org/gmm.html";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
