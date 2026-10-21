{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "datamash";
  version = "1.9";

  src = fetchurl {
    url = "mirror://gnu/datamash/datamash-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-84Lr2gNlDdZ5Fh91j5wKbMkpMhNDjUp3qO2jJarLh9I=";
  };

  meta = {
    description = "Command-line program which performs basic numeric,textual and statistical operations on input textual data files";
    homepage = "https://www.gnu.org/software/datamash/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pSub ];
  };

})
