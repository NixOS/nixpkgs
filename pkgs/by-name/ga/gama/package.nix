{
  lib,
  stdenv,
  fetchurl,
  expat,
  texinfo,
  zip,
  octave,
  libxml2,
}:
stdenv.mkDerivation rec {
  pname = "gama";
  version = "2.26";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-8zKPPpbp66tD2zMmcv2H5xeCSdDhUk0uYPhqwpGqx9Y=";
  };

  buildInputs = [expat];

  nativeBuildInputs = [texinfo zip];

  nativeCheckInputs = [octave libxml2];
  doCheck = true;

  meta = with lib; {
    description = "Tools for adjustment of geodetic networks";
    longDescription = ''
      GNU Gama package is dedicated to the adjustment of surveying networks. It
      is intended for use with traditional geodetic surveyings which are still
      used and needed in special measurements, e.g. underground or high
      precision engineering measurements (engineering geodesy), where the Global
      Positioning System (GPS) cannot be used.

      Adjustment in the local Cartesian coordinate systems is fully supported by
      the command-line program `gama-local` that adjusts surveying (free)
      networks of observed distances, directions, angles, height differences, 3D
      vectors and observed coordinates (coordinates with given
      variance-covariance matrix). You can use any orientation of XY axes and
      observed directions.

      Adjustment in global coordinate systems is supported by `gama-g3` program
      for observed 3D vectors, distances and coordinates.
    '';
    homepage = "https://www.gnu.org/software/gama/";
    downloadPage = "https://mirrors.dotsrc.org/gnu/${pname}/${pname}-${version}.tar.gz";
    changelog = "https://git.savannah.gnu.org/cgit/gama.git/tree/NEWS";
    # See https://git.savannah.gnu.org/cgit/gama.git/tree/ChangeLog for code
    # changes
    license = licenses.gpl3Plus;
    mainProgram = "gama-local";
    platforms = platforms.all;
  };
}
