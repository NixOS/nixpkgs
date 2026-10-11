{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "findent";
  version = "4.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/findent/findent-${finalAttrs.version}.tar.gz";
    hash = "sha256-SkS1LLERxP34h1JDDSAEEVD7tbYPntrDov1RPdyW0e0=";
  };

  enableParallelBuilding = true;

  doCheck = true;

  checkTargets = [ "installcheck" ];

  meta = {
    description = "Fortran source code formatter";
    homepage = "https://sourceforge.net/projects/findent/";
    license = lib.licenses.bsd3;
    mainProgram = "findent";
    maintainers = with lib.maintainers; [ sheepforce ];
    platforms = [ "x86_64-linux" ];
  };
})
