{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gettext,
  libtool,
  libgphoto2,
  fuse3,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gphoto2fs";
  version = "1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "gphoto";
    repo = "gphotofs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3DdL4FQzLEzvREhoZYfZlzZvyow/EATN/Q0HtOmdWKA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gettext
    libtool
    glib
  ];

  buildInputs = [
    libgphoto2
    fuse3
    glib
  ];

  # gphotofs_init() still declares the FUSE 2 callback signature, which GCC 14 rejects
  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/gphotofs --help > /dev/null
  '';

  meta = {
    description = "Fuse FS to mount a digital camera";
    mainProgram = "gphotofs";
    homepage = "http://www.gphoto.org/";
    changelog = "https://github.com/gphoto/gphotofs/releases/tag/${finalAttrs.src.tag}";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
  };
})
