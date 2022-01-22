{ lib, stdenv, fetchurl, autoconf, gfortran, hepmc2, fastjet, lhapdf, rivet, sqlite }:

stdenv.mkDerivation rec {
  pname = "sherpa";
  version = "2.2.12";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/sherpa/SHERPA-MC-${version}.tar.gz";
    sha256 = "sha256-UpRkd1yoKLncllEQUm80DedDtgA8Hm+Kvi/BRVCu0AE=";
  };

  postPatch = lib.optionalString (stdenv.hostPlatform.libc == "glibc") ''
    sed -ie '/sys\/sysctl.h/d' ATOOLS/Org/Run_Parameter.C
  '';

  nativeBuildInputs = [ autoconf gfortran ];

  buildInputs = [ sqlite lhapdf rivet ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-sqlite3=${sqlite.dev}"
    "--enable-hepmc2=${hepmc2}"
    "--enable-fastjet=${fastjet}"
    "--enable-lhapdf=${lhapdf}"
    "--enable-rivet=${rivet}"
    "--enable-pythia"
  ];

  meta = with lib; {
    description = "Simulation of High-Energy Reactions of PArticles in lepton-lepton, lepton-photon, photon-photon, lepton-hadron and hadron-hadron collisions";
    license = licenses.gpl2;
    homepage = "https://gitlab.com/sherpa-team/sherpa";
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
