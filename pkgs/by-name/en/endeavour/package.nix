{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  gettext,
  adwaita-icon-theme,
  glib,
  gtk4,
  wayland,
  libadwaita,
  libpeas,
  gnome-online-accounts,
  gsettings-desktop-schemas,
  evolution-data-server-gtk4,
  libical,
  itstool,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "endeavour";
  version = "43.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Endeavour";
    rev = version;
    sha256 = "sha256-1mCTw+nJ1w7RdCXfPCO31t1aYOq9Bki3EaXsHiiveD0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    wrapGAppsHook4
    itstool
  ];

  buildInputs = [
    glib
    gtk4
    wayland # required by gtk header
    libadwaita
    libpeas
    gnome-online-accounts
    gsettings-desktop-schemas
    adwaita-icon-theme

    # Plug-ins
    evolution-data-server-gtk4 # eds
    libical
  ];

  postPatch = ''
    # Switch to girepository-2.0
    # libpeas1 will be dropped in https://gitlab.gnome.org/World/Endeavour/-/merge_requests/153
    substituteInPlace src/gui/gtd-application.c \
      --replace-fail "#include <girepository.h>" "#include <girepository/girepository.h>" \
      --replace-fail "g_irepository_get_option_group" "gi_repository_get_option_group"
  '';

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Personal task manager for GNOME";
    mainProgram = "endeavour";
    homepage = "https://gitlab.gnome.org/World/Endeavour";
    license = licenses.gpl3Plus;
    teams = [ teams.gnome ];
    platforms = platforms.linux;
  };
}
