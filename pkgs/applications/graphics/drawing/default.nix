{ lib
, fetchFromGitHub
, fetchpatch
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
, itstool
}:

python3.pkgs.buildPythonApplication rec {
  pname = "drawing";
  version = "1.0.0";

  format = "other";

  src = fetchFromGitHub {
    owner = "maoschanz";
    repo = pname;
    rev = version;
    sha256 = "sha256-qNaljtuA5E/QaLJ9QILPRQCqOvKmX4ZGq/0z5unA8KA=";
  };

  patches = [
    # Fix build with meson 0.61, can be removed on next update.
    # https://github.com/NixOS/nixpkgs/issues/167584
    (fetchpatch {
      url = "https://github.com/maoschanz/drawing/commit/6dd271089af76b69322500778e3ad6615a117dcc.patch";
      sha256 = "sha256-4pKWm3LYstVxZ4+gGsZDfM4K+7WBY8EYjylzc/CQZmo=";
      includes = [ "data/meson.build" "help/meson.build" ];
    })
  ];

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
    description = "A free basic image editor, similar to Microsoft Paint, but aiming at the GNOME desktop";
    homepage = "https://maoschanz.github.io/drawing/";
    maintainers = with maintainers; [ mothsart ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
