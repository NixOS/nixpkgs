{ stdenv, fetchurl, gfortran, hepmc2, fastjet, lhapdf, rivet, sqlite }:

stdenv.mkDerivation rec {
  pname = "sherpa";
  version = "2.2.10";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/sherpa/SHERPA-MC-${version}.tar.gz";
    sha256 = "1iwa17s8ipj6a2b8zss5csb1k5y9s5js38syvq932rxcinbyjsl4";
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

  meta = with stdenv.lib; {
    description = "Simulation of High-Energy Reactions of PArticles in lepton-lepton, lepton-photon, photon-photon, lepton-hadron and hadron-hadron collisions";
    license = licenses.gpl2;
    homepage = "https://gitlab.com/sherpa-team/sherpa";
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
