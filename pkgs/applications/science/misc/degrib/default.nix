{ lib
, stdenv
, zlib
, tcl
, tcltls
, tk
, fetchzip
}:

stdenv.mkDerivation {
  pname = "degrib";
  version = "2.25";

  src = fetchzip {
    url = "https://lamp.mdl.nws.noaa.gov/lamp/Data/degrib/download/archive/degrib-20200921.tar.gz";
    sha256 = "1md33zbp3bs85d0v2i77zyq4clabhzqpwg17jy9rnyn40dc1kjc7";
  };

  buildInputs = [
    tcl
    tcltls
    tk
  ];

  # https://gis.stackexchange.com/questions/45259/how-to-compile-degrib-on-ubuntu-12-04-lts
  patchPhase = ''
    runHook prePatch
    cd src
    cp --no-preserve=mode ${zlib.static}/lib/libz.a zlib
    mkdir -p ../bin
    runHook postPatch
  '';

  hardeningDisable = [ "format" ];

  # There seems to be no way to override the install prefix due to hardcoded paths
  postInstall = ''
    mv ../bin $out
  '';

  meta = with lib; {
    description = "Decode NDFD (and other) GRIB2 files";
    homepage = "https://vlab.noaa.gov/web/mdl/degrib-download";
    license = licenses.unfree;
    maintainers = with maintainers; [ boozedog matthewcroughan ];
  };
}
