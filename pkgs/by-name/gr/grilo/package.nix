{
  stdenv,
  lib,
  fetchurl,
  meson,
  mesonEmulatorHook,
  ninja,
  pkg-config,
  python3,
  gettext,
  vala,
  glib,
  liboauth,
  gtk3,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  libxml2,
  gnome,
  gobject-introspection,
  libsoup_3,
  totem-pl-parser,
}:

stdenv.mkDerivation rec {
  pname = "grilo";
  version = "0.3.16"; # if you change minor, also change ./setup-hook.sh

  outputs = [
    "out"
    "dev"
    "man"
    "devdoc"
  ];
  outputBin = "dev";

  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "iEWA6MXs4oDfI6pj/1I0t9SJiKQE331r/M0ed7RzvZY=";
  };

  mesonFlags = [
    "-Denable-gtk-doc=true"
  ];

  nativeBuildInputs =
    [
      meson
      ninja
      pkg-config
      python3
      gettext
      gobject-introspection
      vala
      gtk-doc
      docbook-xsl-nons
      docbook_xml_dtd_43
    ]
    ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      mesonEmulatorHook
    ];

  buildInputs = [
    glib
    liboauth
    gtk3
    libxml2
    libsoup_3
    totem-pl-parser
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/grilo";
    description = "Framework that provides access to various sources of multimedia content, using a pluggable system";
    maintainers = teams.gnome.members;
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
