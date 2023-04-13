{ lib

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
, libadwaita
, webkitgtk_6_0
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gnome-feeds";
  version = "2.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "gfeeds";
    rev = version;
    sha256 = "sha256-XKwRFjz4ocH01mj8KshLGmGxbm/uvDiyYRf65KL0UFw=";
  };

  format = "other";

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    glib # for glib-compile-schemas
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    glib-networking
    gtk4
    libadwaita
    webkitgtk_6_0
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    humanize
    python-dateutil
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
