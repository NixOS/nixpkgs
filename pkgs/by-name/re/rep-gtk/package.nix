{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gtk2-x11,
  librep,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rep-gtk";
  version = "0.90.8.3";

  src = fetchFromGitHub {
    owner = "SawfishWM";
    repo = "rep-gtk";
    tag = "rep-gtk-${finalAttrs.version}";
    hash = "sha256-vEhs7QsQUdeEiHZ6AOri6+SLz3Lq/s6j8rALhY0Xqsc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    librep
  ];

  buildInputs = [
    gtk2-x11
    librep
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=implicit-function-declaration"
    "-Wno-error=int-conversion"
    "-Wno-error=incompatible-pointer-types"
  ];

  patchPhase = ''
    sed -e 's|installdir=$(repexecdir)|installdir=$(libdir)/rep|g' -i Makefile.in
  '';

  meta = {
    homepage = "http://sawfish.tuxfamily.org";
    description = "GTK bindings for librep";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
