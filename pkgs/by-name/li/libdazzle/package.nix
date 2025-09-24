{
  lib,
  stdenv,
  fetchurl,
  ninja,
  meson,
  mesonEmulatorHook,
  pkg-config,
  vala,
  gobject-introspection,
  libxml2,
  gtk-doc,
  docbook_xsl,
  docbook_xml_dtd_43,
  dbus,
  xvfb-run,
  glib,
  gtk3,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "libdazzle";
  version = "3.44.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/libdazzle/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "PNPkXrbiaAywXVLh6A3Y+dWdR2UhLw4o945sF4PRjq4=";
  };

  nativeBuildInputs = [
    ninja
    meson
    pkg-config
    vala
    gobject-introspection
    libxml2
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_43
    dbus
    glib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    xvfb-run
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    glib
    gtk3
  ];

  mesonFlags = [
    "-Denable_gtk_doc=true"
  ];

  doCheck = stdenv.hostPlatform.isLinux;

  checkPhase = ''
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      meson test --print-errorlogs
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "Library to delight your users with fancy features";
    mainProgram = "dazzle-list-counters";
    longDescription = ''
      The libdazzle library is a companion library to GObject and GTK. It
      provides various features that we wish were in the underlying library but
      cannot for various reasons. In most cases, they are wildly out of scope
      for those libraries. In other cases, our design isn't quite generic
      enough to work for everyone.
    '';
    homepage = "https://gitlab.gnome.org/GNOME/libdazzle";
    license = licenses.gpl3Plus;
    teams = [ teams.gnome ];
    platforms = platforms.unix;
  };
}
