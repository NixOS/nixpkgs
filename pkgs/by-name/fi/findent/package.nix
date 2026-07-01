{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "findent";
  version = "4.3.7";

  src = fetchurl {
    url = "mirror://sourceforge/findent/findent-${finalAttrs.version}.tar.gz";
    hash = "sha256-4tqLjAwZYbK8nc5MbKp5ytCSRdNjiL6h/ALE7B/YuZg=";
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
