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
  version = "0-unstable-2026-08-24";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jbrummer";
    repo = "stamp";
    rev = "7b40424fd5e3bb97b7be0fd8be3f2b1759ccefd4";
    hash = "sha256-1RpYMe30ymkb9iy9RwYNahsYqAxPlGrDYy3HfYn/7nM=";
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
