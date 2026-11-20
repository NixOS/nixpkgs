{
  stdenv,
  lib,
  fetchFromGitLab,
  desktop-file-utils,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  webkitgtk_6_0,
  blueprint-compiler,
  evolution-data-server-gtk4,
  glib-networking,
  gpgme,
  gst_all_1,
  libportal-gtk4,
  libpsl,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "stamp";
  version = "0-unstable-2026-09-12";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jbrummer";
    repo = "stamp";
    rev = "0ea93b7bce71a586274a835ffeae69ebc014641b";
    hash = "sha256-GSAYL5nw3oaHHtNX/EOOD1lkKxOPuSzlo9uaVrDupNk=";
  };

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    evolution-data-server-gtk4
    glib-networking
    gpgme
    gst_all_1.gstreamer
    libadwaita
    libportal-gtk4
    libpsl
    webkitgtk_6_0
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch=main" ];
  };

  meta = {
    description = "Modern GTK4 email client for the GNOME ecosystem";
    homepage = "https://gitlab.gnome.org/jbrummer/stamp";
    maintainers = with lib.maintainers; [ onny ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "stamp";
  };
}
