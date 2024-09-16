{ lib, gitUpdater
, fetchFromGitHub
, meson
, ninja
, gettext
, wrapGAppsHook3
, gobject-introspection
, pango
, gdk-pixbuf
, python3
, atk
, gtk3
, hicolor-icon-theme
}:

python3.pkgs.buildPythonApplication rec {
  pname = "diffuse";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "MightyCreak";
    repo = "diffuse";
    rev = "v${version}";
    sha256 = "6GdUtdVhhIQL1cD9/e7Byv37PVKXmzVWhJC6GROK7OA=";
  };

  format = "other";

  nativeBuildInputs = [
    wrapGAppsHook3
    meson
    ninja
    gettext
    gobject-introspection
  ];

  buildInputs = [
    pango
    gdk-pixbuf
    atk
    gtk3
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pycairo
    pygobject3
  ];

  preConfigure = ''
    # app bundle for macos
    substituteInPlace src/diffuse/meson.build data/icons/meson.build src/diffuse/mac-os-app/diffuse-mac.in --replace-fail "/Applications" "$out/Applications";
  '';

  mesonFlags = [
    "-Db_ndebug=true"
  ];

  # to avoid running gtk-update-icon-cache, update-desktop-database and glib-compile-schemas
  DESTDIR = "/";

  makeWrapperArgs = [
      "--prefix XDG_DATA_DIRS : ${hicolor-icon-theme}/share"
  ];

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/MightyCreak/diffuse";
    description = "Graphical tool for merging and comparing text files";
    mainProgram = "diffuse";
    license = licenses.gpl2;
    maintainers = with maintainers; [ k3a ];
    platforms = platforms.unix;
  };
}
