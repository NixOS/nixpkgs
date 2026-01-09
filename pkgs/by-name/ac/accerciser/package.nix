{
  lib,
  fetchurl,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  gnome,
  gtk3,
  wrapGAppsHook3,
  gobject-introspection,
  itstool,
  python3,
  at-spi2-core,
  gettext,
  libwnck,
  librsvg,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "accerciser";
  version = "3.48.0";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/accerciser/${lib.versions.majorMinor version}/accerciser-${version}.tar.xz";
    hash = "sha256-kCiOiQCidKOu4gUw6zkWRZlK6YZyIJFroPXEZ3v+n00=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gobject-introspection # For setup hook
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    at-spi2-core
    gtk3
    libwnck
    librsvg
  ];

  propagatedBuildInputs = with python3.pkgs; [
    dbus-python
    ipython
    pyatspi
    pycairo
    pygobject3
    pyxdg
    setuptools # for pkg_resources
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "accerciser";
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/accerciser";
    changelog = "https://gitlab.gnome.org/GNOME/accerciser/-/blob/${version}/NEWS?ref_type=tags";
    description = "Interactive Python accessibility explorer";
    mainProgram = "accerciser";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
