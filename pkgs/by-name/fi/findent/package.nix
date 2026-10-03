{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "findent";
  version = "4.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/findent/findent-${finalAttrs.version}.tar.gz";
    hash = "sha256-UrQW4hMF/tQsuPm/0Ys2j7UOdHwOXZqzct3tO56hYIk=";
  };

  enableParallelBuilding = true;

  doCheck = true;

  checkTargets = [ "installcheck" ];

  meta = {
    description = "Fortran source code formatter";
    homepage = "https://sourceforge.net/findent/";
    license = lib.licenses.bsd3;
    mainProgram = "findent";
    maintainers = with lib.maintainers; [ sheepforce ];
    platforms = [ "x86_64-linux" ];
  };
})
