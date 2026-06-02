{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "findent";
  version = "4.3.6";

  src = fetchurl {
    url = "mirror://sourceforge/findent/findent-${finalAttrs.version}.tar.gz";
    hash = "sha256-ctg02P8P3R27lCpv3tILSZ5ikn2Va25jHOWIuRfIONQ=";
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
