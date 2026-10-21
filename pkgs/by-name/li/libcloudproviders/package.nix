{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  vala,
  gi-docgen,
  glib,
  mesonEmulatorHook,
  gnome,
}:

# TODO: Add installed tests once https://gitlab.gnome.org/World/libcloudproviders/issues/4 is fixed

stdenv.mkDerivation (finalAttrs: {
  pname = "libcloudproviders";
  version = "0.4.0";

  src = fetchurl {
    url = "mirror://gnome/sources/libcloudproviders/${lib.versions.majorMinor finalAttrs.version}/libcloudproviders-${finalAttrs.version}.tar.xz";
    hash = "sha256-JHsijRAnsmg4aOfXCA04aTpFfpCKrdDBGdUt5Zo5gGQ=";
  };

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  mesonFlags = [
    "-Ddocumentation=true"
  ];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gi-docgen
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    glib
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

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
