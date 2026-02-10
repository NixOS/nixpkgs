{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  jre,
}:

stdenvNoCC.mkDerivation rec {
  pname = "panoply";
  version = "5.9.0";

  src = fetchurl {
    url = "https://www.giss.nasa.gov/tools/panoply/download/PanoplyJ-${version}.tgz";
    hash = "sha256-OCxplchCBx5hCbihg4WNu/RrcYBo5Jfdm1VDIr9swRU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    jarbase=$out/share/panoply
    mkdir -p $out/bin $jarbase/jars

    sed -i "s:^SCRIPTDIR.*:SCRIPTDIR=$jarbase:" panoply.sh

    cp panoply.sh $out/bin/panoply
    cp -r jars $jarbase

    wrapProgram "$out/bin/panoply" --prefix PATH : "${jre}/bin"

    runHook postInstall
  '';

  meta = {
    description = "netCDF, HDF and GRIB Data Viewer";
    homepage = "https://www.giss.nasa.gov/tools/panoply";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.markuskowa ];
    license = lib.licenses.unfree; # Package does not state a license
    mainProgram = "panoply";
  };
}
