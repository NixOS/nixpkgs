{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  gi-docgen,
  meson,
  ninja,
  gnome,
  desktop-file-utils,
  gettext,
  itstool,
  gtk4,
  libadwaita,
  glib,
  atk,
  gobject-introspection,
  vala,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ghex";
  version = "48.3";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/ghex/${lib.versions.major finalAttrs.version}/ghex-${finalAttrs.version}.tar.xz";
    hash = "sha256-y8hEJ7Kt6pQDUCoSXzZrnyiIE/cugb9rGRVGBvFZ3Tk=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    meson
    ninja
    pkg-config
    gi-docgen
    gobject-introspection
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    atk
    glib
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dvapi=true"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # mremap does not exist on darwin
    "-Dmmap-buffer-backend=false"
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "ghex";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/ghex";
    changelog = "https://gitlab.gnome.org/GNOME/ghex/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Hex editor for GNOME desktop environment";
    mainProgram = "ghex";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    teams = [ teams.gnome ];
  };
})
