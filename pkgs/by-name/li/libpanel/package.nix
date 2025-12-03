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
  gtk4,
  libadwaita,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpanel";
  version = "1.10.3";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/libpanel/${lib.versions.majorMinor finalAttrs.version}/libpanel-${finalAttrs.version}.tar.xz";
    hash = "sha256-QqAbr4uURA8ZTqg0KyRL1pkt+wJMoxYMlHf/SY7DorY=";
  };

  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gi-docgen
    gtk4 # gtk4-update-icon-cache
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  mesonFlags = [
    (lib.mesonBool "install-examples" true)
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "libpanel";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Dock/panel library for GTK 4";
    mainProgram = "libpanel-example";
    homepage = "https://gitlab.gnome.org/GNOME/libpanel";
    license = licenses.lgpl3Plus;
    teams = [ teams.gnome ];
    platforms = platforms.unix;
  };
})
