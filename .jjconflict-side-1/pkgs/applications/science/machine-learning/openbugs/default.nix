{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "OpenBUGS";
  version = "3.2.3";

  src = fetchurl {
    url = "https://www.mrc-bsu.cam.ac.uk/wp-content/uploads/2018/04/${pname}-${version}.tar.gz";
    sha256 = "sha256-oonE2gxKw3H4ATImyF69Cp4d7F3puFiVDkhUy4FLTtg=";
  };

  meta = with lib; {
    description = "Open source program for Bayesian modelling based on MCMC";
    homepage = "https://www.mrc-bsu.cam.ac.uk/software/bugs/openbugs/";
    maintainers = with maintainers; [ andresnav ];
    license = licenses.gpl3Only;
    platforms = [ "i686-linux" ];
  };
}
