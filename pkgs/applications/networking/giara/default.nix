{ lib
, fetchFromGitLab
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
  version = "1.1.0";

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = version;
    hash = "sha256-FTy0ElcoTGXG9eV85pUrF35qKDKOfYIovPtjLfTJVOg=";
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
    # blueprint-compiler expects "profile" to be a string.
    substituteInPlace data/ui/headerbar.blp \
      --replace "item { custom: profile; }" 'item { custom: "profile"; }'
  '';

  meta = with lib; {
    description = "A Reddit app, built with Python, GTK and Handy; Created with mobile Linux in mind";
    maintainers = with maintainers; [ dasj19 ];
    homepage = "https://gitlab.gnome.org/World/giara";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "giara";
  };
}
