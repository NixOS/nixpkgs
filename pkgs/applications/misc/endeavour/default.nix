{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
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
, libportal-gtk4
, evolution-data-server-gtk4
, libical
, librest
, json-glib
, itstool
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "endeavour";
  version = "42.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Endeavour";
    rev = "v${version}";
    sha256 = "U91WAoyIeQ0WbFbOCrbFJjbWe2eT7b/VL2M1hNXxyzQ=";
  };

  patches = [
    # fix build race bug https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=257667
    (fetchpatch {
      url = "https://cgit.freebsd.org/ports/plain/deskutils/gnome-todo/files/patch-src_meson.build?id=a4faaf6cf7835014b5f69a337b544ea4ee7f9655";
      sha256 = "sha256-dio4Mg+5OGrnjtRAf4LwowO0sG50HRmlNR16cbDvEUY=";
      extraPrefix = "";
      name = "gnome-todo_meson-build.patch";
    })

    # build: Fix building with -Werror=format-security
    # https://gitlab.gnome.org/World/Endeavour/-/merge_requests/132
    (fetchpatch {
      url = "https://gitlab.gnome.org/World/Endeavour/-/commit/3bad03e90fcc28f6e3f87f2c90df5984dbeb0791.patch";
      sha256 = "sha256-HRkNfhn+EH0Fc+KBDdX1Q+T9QWSctTOn1cvecP2N0zo=";
    })

    # build: Use GNOME module post_install()
    # https://gitlab.gnome.org/World/Endeavour/-/merge_requests/135
    (fetchpatch {
      url = "https://gitlab.gnome.org/World/Endeavour/-/commit/a8daa1d8acd0a5da7aef54d6e16d8a585c71e555.patch";
      sha256 = "sha256-zUTQ36eUMOY9ODAgwSKUhSlB9Cj0Yu/60KjFFW5fx2I=";
    })
  ];

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
    libportal-gtk4 # background
    evolution-data-server-gtk4 # eds
    libical
    librest # todoist
    json-glib # todoist
  ];

  passthru = {
    updateScript = gitUpdater {
      inherit pname version;
      rev-prefix = "v";
    };
  };

  meta = with lib; {
    description = "Personal task manager for GNOME";
    homepage = "https://gitlab.gnome.org/World/Endeavour";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
