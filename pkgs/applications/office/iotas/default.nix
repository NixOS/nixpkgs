{ lib
, python3
, fetchFromGitLab
, meson
, ninja
, pkg-config
, gobject-introspection
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
, glib
, gtk4
, librsvg
, libsecret
, libadwaita
, gtksourceview5
, webkitgtk_6_0
}:

python3.pkgs.buildPythonApplication rec {
  pname = "iotas";
  version = "0.2.7";
  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "cheywood";
    repo = pname;
    rev = version;
    hash = "sha256-k3Qbi/BwkJlQzlyTlo9SjJ1M3zMFHo4669rzd+BBPzQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    librsvg
    libsecret
    libadwaita
    gtksourceview5
    webkitgtk_6_0
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    pygtkspellcheck
    requests
    markdown-it-py
    linkify-it-py
    mdit-py-plugins
  ];

  # prevent double wrapping
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Simple note taking with mobile-first design and Nextcloud sync";
    homepage = "https://gitlab.gnome.org/cheywood/iotas";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
