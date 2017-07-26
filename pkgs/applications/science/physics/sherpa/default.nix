{ stdenv, fetchurl, gfortran, hepmc, fastjet, lhapdf, rivet, sqlite }:

stdenv.mkDerivation rec {
  name = "sherpa-${version}";
  version = "2.2.1";

  src = fetchurl {
    url = "http://www.hepforge.org/archive/sherpa/SHERPA-MC-${version}.tar.gz";
    sha256 = "13vkz6w8kqyv8sgy3mxnlps5ykml5rnlj50vjj0pp9rgbl5y8ali";
  };

  buildInputs = [ gfortran sqlite lhapdf rivet ];

  enableParallelBuilding = true;

  # LLVM 4 doesn't allow ambigous type in std::abs argument
  patches = stdenv.lib.optional stdenv.cc.isClang [ ./explicit_overloads.patch ];

  configureFlags = [
    "--with-sqlite3=${sqlite.dev}"
    "--enable-hepmc2=${hepmc}"
    "--enable-fastjet=${fastjet}"
    "--enable-lhapdf=${lhapdf}"
    "--enable-rivet=${rivet}"
  ];

  CXXFLAGS = "-std=c++11"; # needed for rivet on OSX

  meta = {
    description = "Simulation of High-Energy Reactions of PArticles in lepton-lepton, lepton-photon, photon-photon, lepton-hadron and hadron-hadron collisions";
    license     = stdenv.lib.licenses.gpl2;
    homepage    = https://sherpa.hepforge.org;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
