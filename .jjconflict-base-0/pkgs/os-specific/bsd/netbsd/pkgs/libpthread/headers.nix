{ lib, mkDerivation }:

mkDerivation {
  path = "lib/libpthread";
  pname = "libpthread-headers";
  installPhase = "includesPhase";
  dontBuild = true;
  noCC = true;
  meta.platforms = lib.platforms.netbsd;
}
