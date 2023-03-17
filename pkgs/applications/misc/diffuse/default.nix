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
, gtk3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "diffuse";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "MightyCreak";
    repo = "diffuse";
    rev = "v${version}";
    sha256 = "7tidv01znXYYSOKe3cH2+gSBF00aneL9nealcE5avcE=";
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
    substituteInPlace src/diffuse/meson.build data/icons/meson.build --replace "/Applications" "$out/Applications";
  '';

  mesonFlags = [
    "-Db_ndebug=true"
  ];

  # to avoid running gtk-update-icon-cache, update-desktop-database and glib-compile-schemas
  DESTDIR = "/";

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/MightyCreak/diffuse";
    description = "Graphical tool for merging and comparing text files";
    license = licenses.gpl2;
    maintainers = with maintainers; [ k3a ];
    platforms = platforms.unix;
  };
}
