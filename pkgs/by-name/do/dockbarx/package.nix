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

python3Packages.buildPythonApplication rec {
  pname = "dockbarx";
  version = "1.0-beta4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "xuzhen";
    repo = "dockbarx";
    rev = version;
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

  propagatedBuildInputs = with python3Packages; [
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

  meta = with lib; {
    homepage = "https://github.com/xuzhen/dockbarx";
    description = "Lightweight taskbar/panel replacement which works as a stand-alone dock";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
