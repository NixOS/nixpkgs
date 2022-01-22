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
  version = "0.8.5";

  format = "other";

  src = fetchFromGitHub {
    owner = "maoschanz";
    repo = pname;
    rev = version;
    sha256 = "1q4a1gwmzz0rm10cnd4nzd51zfc2bjc6dsvf90qk1di9x7svis64";
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
