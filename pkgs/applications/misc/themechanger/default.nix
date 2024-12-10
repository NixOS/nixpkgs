{
  lib,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  desktop-file-utils,
  glib,
  gtk3,
  python3,
  gsettings-desktop-schemas,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "themechanger";
  version = "0.11.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "ALEX11BR";
    repo = "ThemeChanger";
    rev = "v${version}";
    sha256 = "sha256-zSbh+mqCKquOyQASwVUW6hghmUc37nTuoa8pWCHM/a8=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook3
    desktop-file-utils
    gtk3
  ];

  buildInputs = [
    glib
    gtk3
    python3
    gsettings-desktop-schemas
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
  ];

  postPatch = ''
    patchShebangs postinstall.py
  '';

  meta = with lib; {
    homepage = "https://github.com/ALEX11BR/ThemeChanger";
    description = "A theme changing utility for Linux";
    mainProgram = "themechanger";
    longDescription = ''
      This app is a theme changing utility for Linux, BSDs, and whatnots.
      It lets the user change GTK 2/3/4, Kvantum, icon and cursor themes, edit GTK CSS with live preview, and set some related options.
      It also lets the user install icon and widget theme archives.
    '';
    maintainers = with maintainers; [ ALEX11BR ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
