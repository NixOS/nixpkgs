{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, gettext
, gnome
, glib
, gtk4
, wayland
, libadwaita
, libpeas
, gnome-online-accounts
, gsettings-desktop-schemas
, evolution-data-server-gtk4
, libical
, itstool
, gitUpdater
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
    gnome.adwaita-icon-theme

    # Plug-ins
    evolution-data-server-gtk4 # eds
    libical
  ];

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Personal task manager for GNOME";
    mainProgram = "endeavour";
    homepage = "https://gitlab.gnome.org/World/Endeavour";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
