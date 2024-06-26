{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "dcw-gmt";
  version = "2.1.2";
  src = fetchurl {
    url = "ftp://ftp.soest.hawaii.edu/gmt/dcw-gmt-${version}.tar.gz";
    sha256 = "sha256-S7hA0HXIuj4UrrQc8XwkI2v/eHVmMU+f91irmXd0XZk=";
  };

  installPhase = ''
    mkdir -p $out/share/dcw-gmt
    cp -rv ./* $out/share/dcw-gmt
  '';

  meta = with lib; {
    homepage = "https://www.soest.hawaii.edu/pwessel/dcw/";
    description = "Vector basemap of the world, for use with GMT";
    longDescription = ''
      DCW-GMT is an enhancement to the original 1:1,000,000 scale vector basemap
      of the world, available from the Princeton University Digital Map and
      Geospatial Information Center. It contains more state boundaries (the
      largest 8 countries are now represented) than the original data
      source. Information about DCW can be found on Wikipedia
      (https://en.wikipedia.org/wiki/Digital_Chart_of_the_World). This data is
      for use by GMT, the Generic Mapping Tools.
    '';
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ tviti ];
  };

}
