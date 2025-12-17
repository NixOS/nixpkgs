{
  fetchurl,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cppi";
  version = "1.18";

  src = fetchurl {
    url = "mirror://gnu/cppi/cppi-${finalAttrs.version}.tar.xz";
    hash = "sha256-EqUFuYhj9sXPH3SfkIC+O0Kz6sWjW1ljDme+pyQTZMo=";
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
})
