{
  lib,
  stdenv,
  fetchurl,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "hepmc";
  version = "2.06.11";

  src = fetchurl {
    url = "http://hepmc.web.cern.ch/hepmc/releases/HepMC-${version}.tar.gz";
    sha256 = "1pp89bs05nv60wjk1690ndwh4dsd5mk20bzsd4a2lklysdifvb6f";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-Dmomentum:STRING=GEV"
    "-Dlength:STRING=MM"
  ];

  meta = with lib; {
    description = "HepMC package is an object oriented event record written in C++ for High Energy Physics Monte Carlo Generators";
    license = licenses.lgpl21;
    homepage = "http://hepmc.web.cern.ch/hepmc/";
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
