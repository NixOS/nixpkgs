{
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3,
  gtk3,
  appstream-glib,
  desktop-file-utils,
  gobject-introspection,
  wrapGAppsHook3,
  glib,
  gdk-pixbuf,
  pango,
  gettext,
  itstool,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "drawing";
  version = "1.0.2";

  format = "other";

  src = fetchFromGitHub {
    owner = "maoschanz";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-kNF9db8NoHWW1A0WEFQzxHqAQ4A7kxInMRZFJOXQX/k=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook3
    glib
    gettext
    itstool
  ];

  buildInputs = [
    glib
    gtk3
    gdk-pixbuf
    pango
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pycairo
    pygobject3
  ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py # patchShebangs requires executable file
    patchShebangs build-aux/meson/postinstall.py
  '';

  strictDeps = false;

  meta = with lib; {
    description = "Free basic image editor, similar to Microsoft Paint, but aiming at the GNOME desktop";
    mainProgram = "drawing";
    homepage = "https://maoschanz.github.io/drawing/";
    changelog = "https://github.com/maoschanz/drawing/releases/tag/${version}";
    maintainers = with maintainers; [ mothsart ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
