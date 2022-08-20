{ lib, gitUpdater
, fetchFromGitHub
, meson
, ninja
, gettext
, wrapGAppsHook
, gobject-introspection
, pango
, gdk-pixbuf
, python3
, atk
}:

python3.pkgs.buildPythonApplication rec {
  pname = "diffuse";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "MightyCreak";
    repo = "diffuse";
    rev = "v${version}";
    sha256 = "0nd1fyl40wyc98jclcxv8zlnm744lrr51fahh5h9v4ksk184h4z8";
  };

  format = "other";

  nativeBuildInputs = [
    wrapGAppsHook
    meson
    ninja
    gettext
    gobject-introspection
  ];

  buildInputs = [
    gobject-introspection
    pango
    gdk-pixbuf
    atk
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pycairo
    pygobject3
  ];

  mesonFlags = [
    "-Db_ndebug=true"
  ];

  # to avoid running gtk-update-icon-cache, update-desktop-database and glib-compile-schemas
  DESTDIR = "/";

  passthru = {
    updateScript = gitUpdater {
      inherit pname version;
      rev-prefix = "v";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/MightyCreak/diffuse";
    description = "Graphical tool for merging and comparing text files";
    license = licenses.gpl2;
    maintainers = with maintainers; [ k3a ];
    platforms = platforms.linux;
  };
}
