{ lib
, fetchFromGitHub
, meson
, ninja
, pkgconfig
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
  version = "0.4.13";

  format = "other";
  
  src = fetchFromGitHub {
    owner = "maoschanz";
    repo = pname;
    rev = version;
    sha256 = "0mj2nmfrckv89srgkn16fnbrb35f5a655ak8bb3rd9na3hd5bq53";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkgconfig
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
