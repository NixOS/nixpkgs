{
  lib,
  stdenv,
  fetchurl,
  gettext,
  gobject-introspection,
  gtk-doc,
  docbook_xsl,
  docbook_xml_dtd_43,
  pkg-config,
  meson,
  ninja,
  vala,
  glib,
  zlib,
  gnome,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gcab";
  version = "1.6";

  outputs = [
    "bin"
    "out"
    "dev"
    "devdoc"
    "installedTests"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gcab/${lib.versions.majorMinor finalAttrs.version}/gcab-${finalAttrs.version}.tar.xz";
    hash = "sha256-LwyWFVd8QSaQniUfneBibD7noVI3bBW1VE3xD8h+Vgs=";
  };

  patches = [
    # allow installing installed tests to a separate output
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    gobject-introspection
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_43
  ];

  buildInputs = [
    glib
    zlib
  ];

  # required by libgcab-1.0.pc
  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dinstalled_tests=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gcab";
      versionPolicy = "none";
    };

    tests = {
      installedTests = nixosTests.installed-tests.gcab;
    };
  };

  meta = {
    description = "GObject library to create cabinet files";
    mainProgram = "gcab";
    homepage = "https://gitlab.gnome.org/GNOME/gcab";
    license = lib.licenses.lgpl21Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.unix;
  };
})
