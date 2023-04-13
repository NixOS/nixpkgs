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
, blueprint-compiler
}:
python3.pkgs.buildPythonApplication rec {
  pname = "giara";
  version = "1.0.1";

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = version;
    hash = "sha256-hKaniW+bbuKUrETMQGWwvC2kyudK9tCE/R69dOFzdQM=";
  };

  nativeBuildInputs = [
    appstream
    meson
    gobject-introspection
    pkg-config
    ninja
    wrapGAppsHook4
    blueprint-compiler
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

  postPatch = ''
    substituteInPlace meson_post_install.py \
      --replace "gtk-update-icon-cache" "gtk4-update-icon-cache"
  '';

  meta = with lib; {
    description = "A Reddit app, built with Python, GTK and Handy; Created with mobile Linux in mind";
    maintainers = with maintainers; [ dasj19 ];
    homepage = "https://gitlab.gnome.org/World/giara";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
