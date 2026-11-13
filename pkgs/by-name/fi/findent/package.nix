{
  stdenv,
  lib,
  fetchurl,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "findent";
  version = "4.4.3";

  src = fetchurl {
    url = "mirror://sourceforge/findent/findent-${finalAttrs.version}.tar.gz";
    hash = "sha256-N9ht5oJUO6VlXAOQfCiIwtZvKaBpndDZUffTJ7RnjSg=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    description = "Fortran source code formatter";
    homepage = "https://sourceforge.net/projects/findent/";
    license = lib.licenses.bsd3;
    mainProgram = "findent";
    maintainers = with lib.maintainers; [ sheepforce ];
    platforms = lib.platforms.linux;
  };
})
