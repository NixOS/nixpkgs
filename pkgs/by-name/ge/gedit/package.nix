{
  stdenv,
  lib,
  meson,
  mesonEmulatorHook,
  fetchFromGitLab,
  pkg-config,
  gtk3,
  gtk-mac-integration,
  glib,
  libgedit-amtk,
  libgedit-gtksourceview,
  libgedit-tepl,
  libpeas,
  libxml2,
  gsettings-desktop-schemas,
  wrapGAppsHook3,
  gtk-doc,
  gobject-introspection,
  docbook-xsl-nons,
  ninja,
  gitUpdater,
  gspell,
  itstool,
  desktop-file-utils,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gedit";
  version = "49.0";

  outputs = [
    "out"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "gedit";
    repo = "gedit";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-IW3zBQOq/eeIjJbgJooHlOd+6/ZHOG6DUspHUlopG8A=";
  };

  patches = [
    # We patch gobject-introspection and meson to store absolute paths to libraries in typelibs
    # but that requires the install_dir is an absolute path.
    ./correct-gir-lib-path.patch
  ];

  nativeBuildInputs = [
    desktop-file-utils
    itstool
    libxml2
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
    gtk-doc
    gobject-introspection
    docbook-xsl-nons
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    glib
    gsettings-desktop-schemas
    gspell
    gtk3
    libgedit-amtk
    libgedit-gtksourceview
    libgedit-tepl
    libpeas
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    gtk-mac-integration
  ];

  # Reliably fails to generate gedit-file-browser-enum-types.h in time
  enableParallelBuilding = false;

  passthru.updateScript = gitUpdater { ignoredVersions = "(alpha|beta|rc).*"; };

  meta = {
    homepage = "https://gitlab.gnome.org/World/gedit/gedit";
    description = "Former GNOME text editor";
    maintainers = with lib.maintainers; [ bobby285271 ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "gedit";
  };
})
