{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gmm";
  version = "5.4.4";

  src = fetchurl {
    url = "mirror://savannah/getfem/stable/gmm-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-FesZQwEbkmZaqzsC7PPO3hz4nqFakAb4HyuizWYqoCs=";
  };

  meta = {
    description = "Generic C++ template library for sparse, dense and skyline matrices";
    homepage = "http://getfem.org/gmm.html";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
