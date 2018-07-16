{ stdenv, fetchurl, gfortran, hepmc, fastjet, lhapdf, rivet, sqlite }:

stdenv.mkDerivation rec {
  name = "sherpa-${version}";
  version = "2.2.5";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/sherpa/SHERPA-MC-${version}.tar.gz";
    sha256 = "0rv14j8gvjjr3darb0wcradlmsnyq915jz7v2yybrjzqfbsr3zb5";
  };

  buildInputs = [ gfortran sqlite lhapdf rivet ];

  enableParallelBuilding = true;

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
