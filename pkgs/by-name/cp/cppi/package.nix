{
  fetchurl,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "cppi";
  version = "1.18";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1jk42cjaggk71rimjnx3qpmb6hivps0917vl3z7wbxk3i2whb98j";
  };

  doCheck = true;

  meta = {
    homepage = "https://savannah.gnu.org/projects/cppi/";

    description = "C preprocessor directive indenter";
    mainProgram = "cppi";

    longDescription = ''
      GNU cppi indents C preprocessor directives to reflect their nesting
      and ensure that there is exactly one space character between each #if,
      #elif, #define directive and the following token.  The number of
      spaces between the `#' and the following directive must correspond
      to the level of nesting of that directive.
    '';

    license = lib.licenses.gpl3Plus;

    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.all;
  };
}
