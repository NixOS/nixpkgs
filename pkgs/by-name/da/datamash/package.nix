{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "datamash";
  version = "1.8";

  src = fetchurl {
    url = "mirror://gnu/datamash/datamash-${version}.tar.gz";
    sha256 = "sha256-etl+jH72Ft0DqlvWeuJMSIJy2z59H1d0FhwYt18p9v0=";
  };

  meta = {
    description = "Command-line program which performs basic numeric,textual and statistical operations on input textual data files";
    homepage = "https://www.gnu.org/software/datamash/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pSub ];
  };

}
