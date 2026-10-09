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
  version = "0-unstable-2026-10-09";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jbrummer";
    repo = "stamp";
    rev = "e89d599592cc7e9189608d5d0814dcbd9ae6dbff";
    hash = "sha256-x5VgMrG2gT6BX/DKQnqmClA0sKJsQw3NM6U25+aSFa0=";
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
