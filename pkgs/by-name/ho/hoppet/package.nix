{
  lib,
  stdenv,
  fetchurl,
  gfortran,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "hoppet";
  version = "1.2.0";

  src = fetchurl {
    url = "https://hoppet.hepforge.org/downloads/${pname}-${version}.tgz";
    sha256 = "0j7437rh4xxbfzmkjr22ry34xm266gijzj6mvrq193fcsfzipzdz";
  };

  nativeBuildInputs = [
    perl
    gfortran
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    patchShebangs .
  '';

<<<<<<< HEAD
  meta = {
    description = "Higher Order Perturbative Parton Evolution Toolkit";
    mainProgram = "hoppet-config";
    license = lib.licenses.gpl2;
    homepage = "https://hoppet.hepforge.org";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
=======
  meta = with lib; {
    description = "Higher Order Perturbative Parton Evolution Toolkit";
    mainProgram = "hoppet-config";
    license = licenses.gpl2;
    homepage = "https://hoppet.hepforge.org";
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
