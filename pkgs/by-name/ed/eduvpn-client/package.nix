{
  lib,
  fetchurl,
  gdk-pixbuf,
  gobject-introspection,
  gtk3,
  libnotify,
  libsecret,
  networkmanager,
  python3Packages,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "eduvpn-client";
  version = "4.4.0";
  format = "pyproject";

  src = fetchurl {
    url = "https://codeberg.org/eduVPN/linux-app/releases/download/${version}/python-${pname}-${version}.tar.xz";
    hash = "sha256-IHRIjryAIeGcFqz5BMWsE0/gClaSmnwWhjc1f1c69vk=";
  };

  nativeBuildInputs = [
    gdk-pixbuf
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libnotify
    libsecret
    networkmanager
  ];

  propagatedBuildInputs = with python3Packages; [
    eduvpn-common
    pygobject3
    setuptools
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://codeberg.org/eduVPN/linux-app/raw/tag/${version}/CHANGES.md";
    description = "Linux client for eduVPN";
    homepage = "https://codeberg.org/eduVPN/linux-app";
    license = licenses.gpl3Plus;
    mainProgram = "eduvpn-gui";
    maintainers = with maintainers; [
      benneti
      jwijenbergh
    ];
    platforms = platforms.linux;
  };
}
