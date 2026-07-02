{
  lib,
  stdenv,
  fetchurl,
  gfortran,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hoppet";
  version = "1.2.0";

  src = fetchurl {
    url = "https://hoppet.hepforge.org/downloads/hoppet-${finalAttrs.version}.tgz";
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

  meta = {
    description = "Higher Order Perturbative Parton Evolution Toolkit";
    mainProgram = "hoppet-config";
    license = lib.licenses.gpl2;
    homepage = "https://hoppet.hepforge.org";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
