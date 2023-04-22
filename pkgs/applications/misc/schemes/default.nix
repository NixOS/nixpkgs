{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, vala
, gtk4
, libgee
, libadwaita
, gtksourceview5
, blueprint-compiler
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
, glib
}:

stdenv.mkDerivation rec {
  pname = "schemes";
  version = "0.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "chergert";
    repo = "schemes";
    rev = version;
    sha256 = "sha256-1mCTw+nJ1w7RdCXfPCO31t1aYOq9Bki3EaXsHiiveD0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    blueprint-compiler
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  meta = with lib; {
    description = "Edit GtkSourceView style-schemes for an application or platform";
    homepage = "https://gitlab.gnome.org/chergert/schemes";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ _0xMRTT ];
    platforms = platforms.linux;
  };
}
