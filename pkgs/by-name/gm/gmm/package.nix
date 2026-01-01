{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "gmm";
  version = "5.4.4";

  src = fetchurl {
    url = "mirror://savannah/getfem/stable/${pname}-${version}.tar.gz";
    sha256 = "sha256-FesZQwEbkmZaqzsC7PPO3hz4nqFakAb4HyuizWYqoCs=";
  };

<<<<<<< HEAD
  meta = {
    description = "Generic C++ template library for sparse, dense and skyline matrices";
    homepage = "http://getfem.org/gmm.html";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Generic C++ template library for sparse, dense and skyline matrices";
    homepage = "http://getfem.org/gmm.html";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
