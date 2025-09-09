{
  lib,
  stdenv,
  fetchsvn,
}:

stdenv.mkDerivation rec {
  pname = "acme";
  version = "unstable-2021-11-05";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/acme-crossass/code-0/trunk";
    rev = "323";
    hash = "sha256-z+dy9/CcC5X6JcIsA1pC4sHMm0kWPgcdeDw4D9KN+7c=";
  };

  sourceRoot = "${src.name}/src";

  postPatch = ''
    substituteInPlace Makefile \
      --replace "= gcc" "?= gcc"
  '';

  enableParallelBuilding = true;

  makeFlags = [ "BINDIR=$(out)/bin" ];

  meta = {
    description = "Multi-platform cross assembler for 6502/6510/65816 CPUs";
    mainProgram = "acme";
    homepage = "https://sourceforge.net/projects/acme-crossass/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ OPNA2608 ];
  };
}
