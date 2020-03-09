{ stdenv, fetchurl, gfortran, hepmc2, fastjet, lhapdf, rivet, sqlite }:

stdenv.mkDerivation rec {
  pname = "sherpa";
  version = "2.2.8";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/sherpa/SHERPA-MC-${version}.tar.gz";
    sha256 = "1al1imdrknvbcy8k113xysc14lln4msbv281bf0kx7p73wz59mv3";
  };

  buildInputs = [ gfortran sqlite lhapdf rivet ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-sqlite3=${sqlite.dev}"
    "--enable-hepmc2=${hepmc2}"
    "--enable-fastjet=${fastjet}"
    "--enable-lhapdf=${lhapdf}"
    "--enable-rivet=${rivet}"
  ];

  CXXFLAGS = "-std=c++11"; # needed for rivet on OSX

  meta = {
    description = "Simulation of High-Energy Reactions of PArticles in lepton-lepton, lepton-photon, photon-photon, lepton-hadron and hadron-hadron collisions";
    license     = stdenv.lib.licenses.gpl2;
    homepage    = https://gitlab.com/sherpa-team/sherpa;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
