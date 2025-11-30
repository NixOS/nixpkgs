{
  lib,
  stdenv,
  fetchFromGitHub,
  desktop-file-utils,
  glib,
  gobject-introspection,
  gtk3,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook3,
  xvfb-run,
  libayatana-appindicator,
  libpeas,
  libXtst,
  zeitgeist,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "diodon";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "diodon-dev";
    repo = "diodon";
    tag = finalAttrs.version;
    hash = "sha256-VCJANasrGmC0jIy8JNNURvmgpL/SLOaVsKo7Pf+X8DQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    desktop-file-utils # for `desktop-file-validate`
    glib # for glib-compile-schemas
    gobject-introspection # For g-ir-compiler
    gtk3 # for gtk-update-icon-cache
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
    xvfb-run
  ];

  buildInputs = [
    gtk3
    libayatana-appindicator
    libpeas
    libXtst
    zeitgeist
  ];

  doCheck = true;

  meta = {
    description = "Aiming to be the best integrated clipboard manager for the Unity desktop";
    homepage = "https://launchpad.net/diodon";
    mainProgram = "diodon";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.sfrijters ];
    platforms = lib.platforms.unix;
  };
})
