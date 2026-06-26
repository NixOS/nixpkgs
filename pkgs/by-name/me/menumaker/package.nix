{
  lib,
  fetchurl,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "menumaker";
  version = "0.99.13";

  src = fetchurl {
    url = "mirror://sourceforge/menumaker/menumaker-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-JBXs5hnt1snbnB1hi7q7HBI7rNp0OoalLeIM0uJCdkE=";
  };

  pyproject = false;

  meta = {
    description = "Heuristics-driven menu generator for several window managers";
    mainProgram = "mmaker";
    homepage = "https://menumaker.sourceforge.net";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.romildo ];
  };
})
