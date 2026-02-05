{
  lib,
  stdenv,
  fetchurl,
  libX11,
  libXext,
  libXi,
  libXmu,
  libXt,
  libXtst,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "imwheel";
  version = "1.0.0pre12";

  src = fetchurl {
    url = "mirror://sourceforge/imwheel/imwheel-${finalAttrs.version}.tar.gz";
    sha256 = "2320ed019c95ca4d922968e1e1cbf0c075a914e865e3965d2bd694ca3d57cfe3";
  };

  buildInputs = [
    libX11
    libXext
    libXi
    libXmu
    libXt
    libXtst
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  makeFlags = [
    "sysconfdir=/etc"
    "ETCDIR=/etc"
  ];

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "ETCDIR=${placeholder "out"}/etc"
  ];

  meta = {
    homepage = "https://imwheel.sourceforge.net/";
    description = "Mouse wheel configuration tool for XFree86/Xorg";
    maintainers = with lib.maintainers; [ jhillyerd ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
    mainProgram = "imwheel";
  };
})
