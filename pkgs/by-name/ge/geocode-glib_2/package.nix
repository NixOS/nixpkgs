{
  stdenv,
  lib,
  fetchurl,
  meson,
  mesonEmulatorHook,
  ninja,
  pkg-config,
  gettext,
  gtk-doc,
  docbook-xsl-nons,
  gobject-introspection,
  gnome,
  libsoup_3,
  json-glib,
  glib,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geocode-glib";
  version = "3.26.4";

  outputs = [
    "out"
    "dev"
    "devdoc"
    "installedTests"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/geocode-glib/${lib.versions.majorMinor finalAttrs.version}/geocode-glib-${finalAttrs.version}.tar.xz";
    sha256 = "LZpoJtFYRwRJoXOHEiFZbaD4Pr3P+YuQxwSQiQVqN6o=";
  };

  patches = [
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    gtk-doc
    docbook-xsl-nons
    gobject-introspection
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    glib
    libsoup_3
    json-glib
  ];

  mesonFlags = [
    "-Dsoup2=false"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "geocode-glib_2";
      packageName = "geocode-glib";
    };
    tests = {
      installed-tests = nixosTests.installed-tests.geocode-glib;
    };
  };

  meta = {
    changelog = "https://gitlab.gnome.org/GNOME/geocode-glib/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Convenience library for the geocoding and reverse geocoding using Nominatim service";
    homepage = "https://gitlab.gnome.org/GNOME/geocode-glib";
    license = lib.licenses.lgpl2Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.unix;
  };
})
