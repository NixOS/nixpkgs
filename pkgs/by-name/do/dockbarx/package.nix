{
  lib,
  fetchFromGitHub,
  glib,
  gobject-introspection,
  gtk3,
  keybinder3,
  libwnck,
  python3Packages,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "dockbarx";
  version = "1.0-beta4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xuzhen";
    repo = "dockbarx";
    rev = finalAttrs.version;
    sha256 = "sha256-J/5KpHptGzgRF1qIGrgjkRR3in5pE0ffkiYVTR3iZKY=";
  };

  nativeBuildInputs = [
    glib.dev
    gobject-introspection
    python3Packages.polib
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libwnck
    keybinder3
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    dbus-python
    pillow
    pygobject3
    pyxdg
    xlib
  ];

  # no tests
  doCheck = false;

  dontWrapGApps = true;

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  # Arguments to be passed to `makeWrapper`, only used by buildPython*
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    homepage = "https://github.com/xuzhen/dockbarx";
    description = "Lightweight taskbar/panel replacement which works as a stand-alone dock";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
  };
})
