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

  meta = with lib; {
    description = "Generic C++ template library for sparse, dense and skyline matrices";
    homepage = "http://getfem.org/gmm.html";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
