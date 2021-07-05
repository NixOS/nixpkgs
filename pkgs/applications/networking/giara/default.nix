{ lib
, fetchFromGitLab
, meson
, gobject-introspection
, pkg-config
, ninja
, python3
, wrapGAppsHook
, gtk3
, gdk-pixbuf
, webkitgtk
, gtksourceview4
, libhandy
, glib-networking
}:

python3.pkgs.buildPythonApplication rec {
  pname = "giara";
  version = "0.3";

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = version;
    sha256 = "004qmkfrgd37axv0b6hfh6v7nx4pvy987k5yv4bmlmkj9sbqm6f9";
  };

  nativeBuildInputs = [
    meson
    gobject-introspection
    pkg-config
    ninja
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    gdk-pixbuf
    webkitgtk
    gtksourceview4
    libhandy
    glib-networking
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
