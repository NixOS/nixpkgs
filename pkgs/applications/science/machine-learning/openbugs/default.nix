{ lib
, stdenv
, fetchurl
, glibc_multi
, gcc_multi
, libgccjit
}:

stdenv.mkDerivation rec {
  pname = "openbugs";
  version = "3.2.3";

  src = fetchurl {
    url = "https://www.mrc-bsu.cam.ac.uk/wp-content/uploads/2018/04/OpenBUGS-${version}.tar.gz";
    sha256 = "sha256-oonE2gxKw3H4ATImyF69Cp4d7F3puFiVDkhUy4FLTtg=";
  };

  nativeBuildInputs = [ glibc_multi gcc_multi libgccjit ];

  configurePhase = ''
    ./configure
  '';

  buildPhase = ''
    cd src
    make
    cd ..
  '';

  installPhase = ''
    mkdir -p $out/bin

    cd src
    cp OpenBUGSCli $out/bin/openbugs
    cd ..

    cp -r lib $out
    cp -r doc $out
  '';


  meta = with lib; {
    description = "Open source program for Bayesian modelling based on MCMC";
    homepage = "https://www.mrc-bsu.cam.ac.uk/software/bugs/openbugs/";
    maintainers = with maintainers; [ andresnav ];
    license = licenses.gpl3;
  };
}
