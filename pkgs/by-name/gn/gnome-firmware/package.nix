{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  appstream-glib,
  desktop-file-utils,
  fwupd,
  gettext,
  glib,
  gtk4,
  libadwaita,
  libxmlb,
  meson,
  ninja,
  pkg-config,
  systemd,
  help2man,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-firmware";
  version = "49.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "gnome-firmware";
    rev = finalAttrs.version;
    sha256 = "sha256-3uU0N40O1eoK5JHWMwacSrBzOTq/c+qYwoH9kBOsqrM=";
  };

  nativeBuildInputs = [
    appstream-glib # for ITS rules
    desktop-file-utils
    gettext
    help2man
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    fwupd
    glib
    gtk4
    libadwaita
    libxmlb
    systemd
  ];

  mesonFlags = [
    "-Dconsolekit=false"
  ];

  passthru.updateScript = gitUpdater {
    ignoredVersions = "(alpha|beta|rc).*";
  };

  meta = {
    homepage = "https://gitlab.gnome.org/World/gnome-firmware";
    description = "Tool for installing firmware on devices";
    mainProgram = "gnome-firmware";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
})
