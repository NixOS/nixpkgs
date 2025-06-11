{
  lib,
  stdenv,
  fetchurl,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ms-sys";
  version = "2.8.0";

  src = fetchurl {
    url = "mirror://sourceforge/ms-sys/ms-sys-${finalAttrs.version}.tar.gz";
    hash = "sha256-qQLuPr0MtwOO0HfjqoqMgzWmxHL1BW1+CK8z1+eD8Vc=";
  };

  nativeBuildInputs = [ gettext ];

  enableParallelBuilding = true;

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Program for writing Microsoft-compatible boot records";
    homepage = "https://ms-sys.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux;
    mainProgram = "ms-sys";
  };
})
