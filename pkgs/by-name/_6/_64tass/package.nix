{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "64tass";
  version = "1.60.3243";

  src = fetchzip {
    url = "mirror://sourceforge/tass64/64tass-${finalAttrs.version}-src.zip";
    hash = "sha256-73/MoQqqM966xtN4D8F85HZSw/gEpcFQ2JiH3k6vI+4=";
  };

  installFlags = [ "prefix=$(out)" ];

  meta = {
    homepage = "https://tass64.sourceforge.net/";
    description = "Multi pass optimizing macro assembler for the 65xx series of processors";
    license = [
      lib.licenses.gpl2Plus
      lib.licenses.lgpl2Only
      lib.licenses.lgpl21Only
      lib.licenses.mit
    ];
    maintainers = [ lib.maintainers.matthewcroughan ];
    platforms = lib.platforms.linux;
  };
})
