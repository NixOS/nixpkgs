{ lib
, fetchFromGitHub
, wrapGAppsHook4
, meson
, ninja
, pkg-config
, glib
, glib-networking
, desktop-file-utils
, gettext
, librsvg
, blueprint-compiler
, python3Packages
, sassc
, appstream-glib
, libadwaita
, libportal
, libportal-gtk4
, libsoup_3
, gobject-introspection
}:

python3Packages.buildPythonApplication rec {
  pname = "gradience";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "GradienceTeam";
    repo = "Gradience";
    # See https://github.com/GradienceTeam/Gradience/releases/tag/0.4.1-patch1
    rev = "0.4.1-patch1";
    sha256 = "sha256-5jloFbimJC4jP1C1uS8a9VlqyR5qqDuqcKvUXwr9SjY=";
  };

  format = "other";
  dontWrapGApps = true;

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    desktop-file-utils
    gettext
    glib
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    sassc
  ];

  buildInputs = [
    glib-networking
    libadwaita
    libportal
    libportal-gtk4
    librsvg
    libsoup_3
  ];

  propagatedBuildInputs = with python3Packages; [
    anyascii
    jinja2
    lxml
    material-color-utilities
    pygobject3
    svglib
    yapsy
    packaging
  ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    homepage = "https://github.com/GradienceTeam/Gradience";
    description = "Customize libadwaita and GTK3 apps (with adw-gtk3)";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
