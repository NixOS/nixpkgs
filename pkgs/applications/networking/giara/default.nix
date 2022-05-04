{ lib
, fetchFromGitLab
, fetchpatch
, meson
, gobject-introspection
, pkg-config
, ninja
, python3
, wrapGAppsHook4
, gtk4
, gdk-pixbuf
, webkitgtk
, gtksourceview5
, glib-networking
, libadwaita
, appstream
}:

python3.pkgs.buildPythonApplication rec {
  pname = "giara";
  version = "1.0";

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = version;
    hash = "sha256-xDIzgr8zYal0r0sASWqiSZANCMC52LrVmLjlnGAd2Mg=";
  };

  nativeBuildInputs = [
    appstream
    meson
    gobject-introspection
    pkg-config
    ninja
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gdk-pixbuf
    webkitgtk
    gtksourceview5
    glib-networking
    libadwaita
  ];

  pythonPath = with python3.pkgs; [
    pygobject3
    pycairo
    python-dateutil
    praw
    pillow
    mistune
    beautifulsoup4
  ];

  patches = [
    # Proper support for gtk4 and libadwaita
    # @TODO: Remove when bumping the version.
    (fetchpatch {
      name = "giara-gtk4-libadwaita.patch";
      url = "https://gitlab.gnome.org/World/giara/-/commit/6204427f8b8e3d8c72b669717a3f129ffae401d9.patch";
      sha256 = "sha256-E8kbVsACPD2gkfNrzYUy0+1U7+/pIkUu4rCkX+xY0us=";
    })
  ];

  postPatch = ''
    substituteInPlace meson_post_install.py \
      --replace "gtk-update-icon-cache" "gtk4-update-icon-cache"
  '';

  # Fix setup-hooks https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  meta = with lib; {
    description = "A Reddit app, built with Python, GTK and Handy; Created with mobile Linux in mind";
    maintainers = with maintainers; [ dasj19 ];
    homepage = "https://gitlab.gnome.org/World/giara";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
