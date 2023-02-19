{ lib
, callPackage

, fetchFromGitLab

, appstream
, blueprint-compiler
, gobject-introspection
, meson
, ninja
, pkg-config
, wrapGAppsHook

, glib
, glib-networking
, gtk4
, libhandy
, libadwaita
, webkitgtk
, webkitgtk_5_0
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gnome-feeds";
  version = "2.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "gfeeds";
    rev = version;
    sha256 = "sha256-qKSgqYt9aIg62VVD7WeW/Pid/7M4fKlCyZIo1cijCi8=";
  };

  format = "other";

  nativeBuildInputs = [
    # appstream
    glib # for glib-compile-schemas
    blueprint-compiler
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gtk4
    libadwaita
    glib
    glib-networking
    webkitgtk_5_0
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    python-dateutil
    humanize
    python-magic
    pillow
    pygments
    pygobject3
    readability-lxml
    syndom
    pytz
    requests
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "An RSS/Atom feed reader for GNOME";
    homepage = "https://gitlab.gnome.org/World/gfeeds";
    license = licenses.gpl3Plus;
    maintainers = [
      maintainers.pbogdan
    ];
    platforms = platforms.linux;
  };
}
