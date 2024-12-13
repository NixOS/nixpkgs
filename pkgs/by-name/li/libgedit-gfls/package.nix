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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgedit-gfls";
  version = "0.2.1";

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
    rev = finalAttrs.version;
    hash = "sha256-kMkqEly8RDc5eKqUupQD4tkVIXxL1rt4e/OCAPoutIg=";
  };

  nativeBuildInputs =
    [
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

  meta = {
    homepage = "https://gitlab.gnome.org/World/gedit/libgedit-gfls";
    description = "Module dedicated to file loading and saving";
    maintainers = with lib.maintainers; [ bobby285271 ];
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
  };
})
