{ lib
, callPackage
, stdenv
, fetchFromGitLab

, appstream
, gobject-introspection
, meson
, ninja
, pkg-config
, wrapGAppsHook

, glib
, gtk3
, libhandy
, listparser ? callPackage ./listparser.nix { }
, webkitgtk
, python3
}:
python3.pkgs.buildPythonApplication rec {
  pname = "feeds";
  version = "0.16.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "gfeeds";
    rev = version;
    sha256 = "10hq06nx7lcm3dqq34qkxc6k6383mvjs7pxii9y9995d9kk5a49k";
  };

  format = "other";

  nativeBuildInputs = [
    appstream
    glib # for glib-compile-schemas
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    libhandy
    webkitgtk
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    dateutil
    feedparser
    html5lib
    listparser
    lxml
    pillow
    pygments
    pygobject3
    pyreadability
    pytz
    requests
  ];

  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    inherit listparser;
  };

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
