{
  lib,
  stdenv,
  fetchurl,
  meson,
  mesonEmulatorHook,
  ninja,
  pkg-config,
  vala,
  gtk-doc,
  docbook_xsl,
  docbook_xml_dtd_412,
  glib,
  gdk-pixbuf,
  gobject-introspection,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "libmediaart";
  version = "1.9.6";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "w7xQJdfbOAWH+cjrgAxhH2taFta0t4/P+T9ih2pnfxc=";
  };

  nativeBuildInputs =
    [
      meson
      ninja
      pkg-config
      vala
      gtk-doc
      docbook_xsl
      docbook_xml_dtd_412
      gobject-introspection
    ]
    ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      mesonEmulatorHook
    ];

  buildInputs = [
    glib
    gdk-pixbuf
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "Library tasked with managing, extracting and handling media art caches";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
