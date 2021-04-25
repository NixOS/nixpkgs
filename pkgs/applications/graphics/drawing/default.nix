{ lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, python3
, gtk3
, appstream-glib
, desktop-file-utils
, gobject-introspection
, wrapGAppsHook
, glib
, gdk-pixbuf
, pango
, gettext
}:

python3.pkgs.buildPythonApplication rec {
  pname = "drawing";
  version = "0.8.0";

  format = "other";

  src = fetchFromGitHub {
    owner = "maoschanz";
    repo = pname;
    rev = version;
    sha256 = "03cx6acb0ph7b3difshjfddi8ld79wp8d12bdp7dp1q1820j5mz0";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook
    glib
    gettext
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
    description = "A free basic image editor, similar to Microsoft Paint, but aiming at the GNOME desktop";
    homepage = "https://maoschanz.github.io/drawing/";
    maintainers = with maintainers; [ mothsart ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
