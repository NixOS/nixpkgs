{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gshhg-gmt";
  version = "2.3.7";
  src = fetchurl {
    url = "ftp://ftp.soest.hawaii.edu/gmt/gshhg-gmt-${finalAttrs.version}.tar.gz";
    sha256 = "9bb1a956fca0718c083bef842e625797535a00ce81f175df08b042c2a92cfe7f";
  };

  installPhase = ''
    mkdir -p $out/share/gshhg-gmt
    cp -rv ./* $out/share/gshhg-gmt
  '';

  meta = with lib; {
    homepage = "https://www.soest.hawaii.edu/pwessel/gshhg/";
    description = "High-resolution shoreline data set, for use with GMT";
    longDescription = ''
      GSHHG is a high-resolution shoreline data set amalgamated from two
      databases: Global Self-consistent Hierarchical High-resolution Shorelines
      (GSHHS) and CIA World Data Bank II (WDBII). GSHHG contains vector
      descriptions at five different resolutions of land outlines, lakes,
      rivers, and political boundaries. This data is for use by GMT, the Generic
      Mapping Tools.
    '';
    license = licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ tviti ];
    teams = [ lib.teams.geospatial ];
  };

})
