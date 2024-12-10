{
  lib,
  callPackage,

  fetchFromGitLab,

  appstream,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,

  glib,
  glib-networking,
  gtk3,
  libhandy,
  listparser ? callPackage ./listparser.nix { },
  webkitgtk,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gnome-feeds";
  version = "0.16.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "gfeeds";
    rev = version;
    sha256 = "sha256-66dwVR9owg050aHCHJek7jYnT+/yyCKo4AaUE0hCqBA=";
  };

  format = "other";

  nativeBuildInputs = [
    appstream
    glib # for glib-compile-schemas
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    glib-networking
    gtk3
    libhandy
    webkitgtk
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    python-dateutil
    feedparser
    html5lib
    listparser
    lxml
    pillow
    pygments
    pygobject3
    readability-lxml
    pytz
    requests
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    inherit listparser;
  };

  meta = with lib; {
    description = "An RSS/Atom feed reader for GNOME";
    mainProgram = "gfeeds";
    homepage = "https://gitlab.gnome.org/World/gfeeds";
    license = licenses.gpl3Plus;
    maintainers = [
      maintainers.pbogdan
    ];
    platforms = platforms.linux;
  };
}
