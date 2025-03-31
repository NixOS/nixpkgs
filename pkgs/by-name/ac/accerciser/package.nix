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
  version = "3.46.2";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/accerciser/${lib.versions.majorMinor version}/accerciser-${version}.tar.xz";
    hash = "sha256-r/RpRR8k5YdpPE9/en+GpQU8ZrIDOndDrZ2DhHSWdw4=";
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

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/accerciser";
    changelog = "https://gitlab.gnome.org/GNOME/accerciser/-/blob/${version}/NEWS?ref_type=tags";
    description = "Interactive Python accessibility explorer";
    mainProgram = "accerciser";
    maintainers = teams.gnome.members;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
