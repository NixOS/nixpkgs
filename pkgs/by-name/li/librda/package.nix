{
  stdenv,
  lib,
  fetchFromGitHub,
  testers,
  autoreconfHook,
  glib,
  gobject-introspection,
  gtk3,
  intltool,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "librda";
  version = "0.0.5-unstable-2023-09-15";

  src = fetchFromGitHub {
    owner = "ArcticaProject";
    repo = "librda";
    rev = "d7ed1368145e39b0c761947a32fa50493e70f554";
    hash = "sha256-k6dmwIndLy9S7f0AU7FIm1S7MYfyvDuhMLMuNgHGsYo=";
  };

  outputs = [
    "out"
    "dev"
    "bin"
  ];

  patches = [
    # Use proper gettext instead of GLib macros
    # Remove when https://github.com/ArcticaProject/librda/pull/10 merged & in release
    ./1001-configure-GLib-gettext-is-deprecated-use-regular-get.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    glib
    gobject-introspection
    intltool
    pkg-config
  ];

  buildInputs = [
    gtk3
  ];

  enableParallelBuilding = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Remote Desktop Awareness Shared Library";
    homepage = "https://github.com/ArcticaProject/librda";
    license = licenses.gpl2Plus;
    mainProgram = "rdacheck";
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
    pkgConfigModules = [
      "rda"
    ];
  };
})
