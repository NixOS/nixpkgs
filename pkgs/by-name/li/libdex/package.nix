{
  stdenv,
  lib,
  fetchurl,
  gi-docgen,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  vala,
  glib,
  liburing,
  gnome,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdex";
  version = "1.1.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libdex/${lib.versions.majorMinor finalAttrs.version}/libdex-${finalAttrs.version}.tar.xz";
    hash = "sha256-qeBMir7gHJp88RSMW3qma6N37+avbYOAHU/RqlUhmqo=";
  };

  nativeBuildInputs = [
    gi-docgen
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
    python3
  ];

  buildInputs = [
    glib
    liburing
  ];

  mesonFlags = [
    "-Ddocs=true"
  ];

  doCheck = true;

  # test-dbus tries to access /etc/machine-id
  postPatch = ''
    substituteInPlace "testsuite/meson.build" --replace-fail \
      "'test-dbus': {'extra-sources': dbus_foo, 'disable': not have_gdbus_codegen}," \
      "'test-dbus': {'extra-sources': dbus_foo, 'disable': true},"
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru.updateScript = gnome.updateScript {
    packageName = "libdex";
    versionPolicy = "odd-unstable";
  };

  meta = {
    description = "Library supporting deferred execution for GNOME and GTK";
    homepage = "https://gitlab.gnome.org/GNOME/libdex";
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.lgpl21Plus;
  };
})
