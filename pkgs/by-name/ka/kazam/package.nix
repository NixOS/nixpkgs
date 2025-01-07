{
  lib,
  fetchFromGitHub,
  substituteAll,
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
  version = "unstable-2021-06-22";

  src = fetchFromGitHub {
    owner = "niknah";
    repo = "kazam";
    rev = "13f6ce124e5234348f56358b9134a87121f3438c";
    sha256 = "1jk6khwgdv3nmagdgp5ivz3156pl0ljhf7b6i4b52w1h5ywsg9ah";
  };

  nativeBuildInputs = [
    gobject-introspection
    python3Packages.distutils-extra
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

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    pyxdg
    pycairo
    dbus-python
    xlib
  ];

  patches = [
    # Fix paths
    (substituteAll {
      src = ./fix-paths.patch;
      libcanberra = libcanberra-gtk3;
      inherit libpulseaudio;
    })
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Screencasting program created with design in mind";
    homepage = "https://github.com/niknah/kazam";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.domenkozar ];
    mainProgram = "kazam";
  };
}
