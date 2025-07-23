{
  lib,
  fetchFromGitHub,
  replaceVars,
  python3Packages,
  gst_all_1,
  wrapGAppsHook3,
  gobject-introspection,
  gtk3,
  libwnck,
  keybinder3,
  intltool,
  libcanberra-gtk3,
  libappindicator-gtk3,
  libpulseaudio,
  libgudev,
}:

python3Packages.buildPythonApplication rec {
  pname = "kazam";
  version = "1.5.5-unstable-2025-01-02";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "niknah";
    repo = "kazam";
    rev = "b6c1bddc9ac93aad50476f2c87fec9f0cf204f2a";
    hash = "sha256-xllpNoKeSXVWZhzlY60ZDnWIKoAW+cd08Tb1413Ldpk=";
  };

  nativeBuildInputs = [
    gobject-introspection
    intltool
    wrapGAppsHook3
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gtk3
    libwnck
    keybinder3
    libappindicator-gtk3
    libgudev
  ];

  build-system = with python3Packages; [
    setuptools
    distutils-extra
  ];

  dependencies = with python3Packages; [
    distro
    pygobject3
    pyxdg
    pycairo
    dbus-python
    xlib
  ];

  patches = [
    # Fix paths
    (replaceVars ./fix-paths.patch {
      libcanberra = libcanberra-gtk3;
      inherit libpulseaudio;
    })
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "kazam" ];

  meta = {
    description = "Screencasting program created with design in mind";
    homepage = "https://github.com/niknah/kazam";
    changelog = "https://github.com/niknah/kazam/raw/${src.rev}/NEWS";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "kazam";
  };
}
