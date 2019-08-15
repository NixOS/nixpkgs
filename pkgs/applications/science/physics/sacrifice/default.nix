{ stdenv, fetchurl, boost, hepmc2, lhapdf, pythia, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "sacrifice";
  version = "1.0.0";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/agile/Sacrifice-1.0.0.tar.gz";
    sha256 = "10bvpq63kmszy1habydwncm0j1dgvam0fkrmvkgbkvf804dcjp6g";
  };

  buildInputs = [ boost hepmc2 lhapdf pythia ];
  nativeBuildInputs = [ makeWrapper ];

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
    "--with-HepMC=${hepmc2}"
    "--with-pythia=${pythia}"
  ];

  postInstall = if stdenv.isDarwin then ''
    install_name_tool -add_rpath ${pythia}/lib "$out"/bin/run-pythia
  '' else ''
    wrapProgram $out/bin/run-pythia \
      --prefix LD_LIBRARY_PATH : "${pythia}/lib"
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
