{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  libxslt,
  docbook-xsl-ns,
  glib,
  gdk-pixbuf,
  gnome,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  gobject-introspection,
}:

stdenv.mkDerivation rec {
  pname = "libnotify";
  version = "0.8.6";

  outputs = [
    "out"
    "man"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-xVQKrvtg4dY7HFh8BfIoTr5y7OfQwOXkp3jP1YRLa1g=";
  };

  mesonFlags = [
    # disable tests as we don't need to depend on GTK (2/3)
    "-Dtests=false"
    "-Ddocbook_docs=disabled"
    "-Dgtk_doc=false"
    "-Dintrospection=${if withIntrospection then "enabled" else "disabled"}"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    libxslt
    docbook-xsl-ns
    glib # for glib-mkenums needed during the build
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
  ];

  propagatedBuildInputs = [
    gdk-pixbuf
    glib
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "Library that sends desktop notifications to a notification daemon";
    homepage = "https://gitlab.gnome.org/GNOME/libnotify";
    license = licenses.lgpl21;
    teams = [ teams.gnome ];
    mainProgram = "notify-send";
    platforms = platforms.unix;
  };
}
