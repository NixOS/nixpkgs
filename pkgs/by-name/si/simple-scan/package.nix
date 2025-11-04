{
  lib,
  stdenv,
  fetchurl,
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
  gnome,
  gobject-introspection,
}:

stdenv.mkDerivation rec {
  pname = "simple-scan";
  version = "49.1";

  src = fetchurl {
    url = "mirror://gnome/sources/simple-scan/${lib.versions.major version}/simple-scan-${version}.tar.xz";
    hash = "sha256-mujUFR7K+VhF65+ZtDbVecg48s8Cdj+6O8A3gCUb4zQ=";
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
    updateScript = gnome.updateScript {
      packageName = "simple-scan";
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
