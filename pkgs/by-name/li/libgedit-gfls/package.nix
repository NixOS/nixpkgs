{
  stdenv,
  lib,
  fetchFromGitLab,
  docbook-xsl-nons,
  gobject-introspection,
  gtk-doc,
  meson,
  ninja,
  pkg-config,
  mesonEmulatorHook,
  gtk3,
  glib,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgedit-gfls";
  version = "0.3.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "gedit";
    repo = "libgedit-gfls";
    tag = finalAttrs.version;
    hash = "sha256-X56QPcmNB0Ey+kzSqDnb6/j6/w7IU7MFSAxW8mX8I3w=";
  };

  nativeBuildInputs = [
    docbook-xsl-nons
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    # Required by libgedit-gfls-1.pc
    glib
  ];

  passthru.updateScript = gitUpdater { ignoredVersions = "(alpha|beta|rc).*"; };

  meta = {
    homepage = "https://gitlab.gnome.org/World/gedit/libgedit-gfls";
    description = "Module dedicated to file loading and saving";
    maintainers = with lib.maintainers; [ bobby285271 ];
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
  };
})
