{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dcw-gmt";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "GenericMappingTools";
    repo = "dcw-gmt";
    tag = finalAttrs.version;
    hash = "sha256-OgFonNbhvzRfQZksnwIbgASbMGnL0bmD4wkXZBl3kIU=";
  };

  installPhase = ''
    mkdir -p $out/share/dcw-gmt
    cp -rv ./* $out/share/dcw-gmt
  '';

  meta = with lib; {
    homepage = "https://github.com/GenericMappingTools/dcw-gmt";
    description = "Vector basemap of the world, for use with GMT";
    longDescription = ''
      The Digital Chart of the World is a comprehensive 1:1,000,000 scale vector
      basemap of the world. The charts were designed to meet the needs of pilots
      and air crews in medium- and low-altitude en route navigation and to
      support military operational planning, intelligence briefings, and other
      needs. For basic background information about DCW, see the [Wikipedia
      entry](http://en.wikipedia.org/wiki/Digital_Chart_of_the_World).

      DCW-GMT is an enhancement to DCW in a few ways:

      - It contains more state boundaries (the largest 8 countries, Great Britain and Norway are now represented).
      - The data have been reformatted to save space and are distributed as a single deflated netCDF-4 file.
    '';
    license = licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ tviti ];
    teams = [ lib.teams.geospatial ];
  };

})
