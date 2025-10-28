{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  gettext,
  itstool,
  wrapGAppsHook4,
  cairo,
  gdk-pixbuf,
  colord,
  glib,
  libadwaita,
  gtk4,
  gusb,
  packagekit,
  libwebp,
  libxml2,
  sane-backends,
  vala,
  gitUpdater,
  gobject-introspection,
}:

stdenv.mkDerivation rec {
  pname = "simple-scan";
  version = "48.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "simple-scan";
    tag = version;
    hash = "sha256-Y+uVAW0jpXJgadP6CjG8zeLgikFY2Pm0z4TZoyYK4+g=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    itstool
    pkg-config
    wrapGAppsHook4
    libxml2
    gobject-introspection # For setup hook
    vala
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    colord
    glib
    gusb
    libadwaita
    gtk4
    libwebp
    packagekit
    sane-backends
  ];

  doCheck = true;

  passthru = {
    updateScript = gitUpdater {
      # Ignore tags like 48.1-2, which actually does not introduce any changes.
      ignoredVersions = "-";
    };
  };

  meta = {
    description = "Simple scanning utility";
    mainProgram = "simple-scan";
    longDescription = ''
      A really easy way to scan both documents and photos. You can crop out the
      bad parts of a photo and rotate it if it is the wrong way round. You can
      print your scans, export them to pdf, or save them in a range of image
      formats. Basically a frontend for SANE - which is the same backend as
      XSANE uses. This means that all existing scanners will work and the
      interface is well tested.
    '';
    homepage = "https://gitlab.gnome.org/GNOME/simple-scan";
    changelog = "https://gitlab.gnome.org/GNOME/simple-scan/-/blob/${version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
}
