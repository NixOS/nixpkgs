{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  vala,
  gtk-doc,
  docbook_xsl,
  glib,
  mesonEmulatorHook,
  gnome,
}:

# TODO: Add installed tests once https://gitlab.gnome.org/World/libcloudproviders/issues/4 is fixed

stdenv.mkDerivation (finalAttrs: {
  pname = "libcloudproviders";
  version = "0.3.6";

  src = fetchurl {
    url = "mirror://gnome/sources/libcloudproviders/${lib.versions.majorMinor finalAttrs.version}/libcloudproviders-${finalAttrs.version}.tar.xz";
    hash = "sha256-O3URCzpP3vTFxaRA5IcB/gVNKuBh0VbIkTa7W6BedLc=";
  };

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  mesonFlags = [
    "-Denable-gtk-doc=true"
  ];

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gtk-doc
    docbook_xsl
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [ glib ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "libcloudproviders";
    };
  };

  meta = {
    description = "DBus API that allows cloud storage sync clients to expose their services";
    homepage = "https://gitlab.gnome.org/World/libcloudproviders";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = lib.platforms.unix;
  };
})
