{ stdenv, fetchurl, boost, hepmc, lhapdf, pythia }:

stdenv.mkDerivation rec {
  name = "sacrifice-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "http://www.hepforge.org/archive/agile/Sacrifice-1.0.0.tar.gz";
    sha256 = "10bvpq63kmszy1habydwncm0j1dgvam0fkrmvkgbkvf804dcjp6g";
  };

  buildInputs = [ boost hepmc lhapdf pythia ];

  patches = [
    ./compat.patch
  ];

  preConfigure = ''
    substituteInPlace configure --replace HAVE_LCG=yes HAVE_LCG=no
  ''
  + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace LIB_SUFFIX=\"so\" LIB_SUFFIX=\"dylib\"
  '';

  configureFlags = [
    "--with-HepMC=${hepmc}"
    "--with-pythia=${pythia}"
  ];

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -add_rpath ${pythia}/lib "$out"/bin/run-pythia
  '';

  enableParallelBuilding = true;

  meta = {
    description = "A standalone contribution to AGILe for steering Pythia 8";
    license     = stdenv.lib.licenses.gpl2;
    homepage    = https://agile.hepforge.org/trac/wiki/Sacrifice;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
