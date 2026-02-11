{
  lib,
  gitUpdater,
  fetchFromGitHub,
  meson,
  ninja,
  gettext,
  wrapGAppsHook3,
  gobject-introspection,
  pango,
  gdk-pixbuf,
  python3,
  atk,
  gtk3,
  hicolor-icon-theme,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "diffuse";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "MightyCreak";
    repo = "diffuse";
    rev = "v${finalAttrs.version}";
    sha256 = "Svt+llBwJKGXRJZ96dzzdzpL/5jrzXXM/FPZwA7Es8s=";
  };

  pyproject = false;

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

  meta = {
    homepage = "https://github.com/MightyCreak/diffuse";
    description = "Graphical tool for merging and comparing text files";
    mainProgram = "diffuse";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ k3a ];
    platforms = lib.platforms.unix;
  };
})
