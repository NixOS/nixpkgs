{ stdenv, fetchurl, gfortran, lhapdf }:

stdenv.mkDerivation rec {
  name = "MCFM-${version}";
  version = "8.2";

  src = fetchurl {
    url = "https://mcfm.fnal.gov/${name}.tar.gz";
    sha256 = "1z9vm3dsy4sf3n8vhrkif5hh4yv59fwsfd98vhwjbsfbsf13fph7";
  };

  preConfigure = ''
    patchShebangs ./
    substituteInPlace makefile \
      --replace "-Wl,-rpath=" "-Wl,-rpath,"
  '';

  buildInputs = [ gfortran ];
  configurePhase = ''
    runHook preConfigure

    ./Install

    runHook postConfigure
  '';

  makeFlags = [
    "PDFROUTINES=LHAPDF"
    "LHAPDFLIB=${lhapdf}/lib"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/bin
    mv Bin/mcfm_omp "$out"/bin/mcfm_omp
    mkdir "$out"/share
    mv Bin/ "$out"/share/MCFM/

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Monte Carlo for FeMtobarn processes";
    homepage = https://mcfm.fnal.gov;
    license = licenses.free;
    maintainers = with maintainers; [ veprbl ];
    platforms = platforms.unix;
  };
}
