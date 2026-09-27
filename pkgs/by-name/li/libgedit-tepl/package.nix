{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  mesonEmulatorHook,
  ninja,
  gobject-introspection,
  gtk3,
  icu,
  libhandy,
  libgedit-amtk,
  libgedit-gfls,
  libgedit-gtksourceview,
  pkg-config,
  gtk-doc,
  docbook-xsl-nons,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgedit-tepl";
  version = "6.14.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "gedit";
    repo = "libgedit-tepl";
    tag = finalAttrs.version;
    hash = "sha256-KtmExJCEfa4c6alrtWOLNSKZUs65tZ7p9zcT9f8ZC+k=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    gobject-introspection
    pkg-config
    gtk-doc
    docbook-xsl-nons
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    icu
    libhandy
  ];

  propagatedBuildInputs = [
    gtk3
    libgedit-amtk
    libgedit-gfls
    libgedit-gtksourceview
  ];

  passthru.updateScript = gitUpdater { ignoredVersions = "(alpha|beta|rc).*"; };

  meta = {
    homepage = "https://gitlab.gnome.org/World/gedit/libgedit-tepl";
    description = "Text editor product line";
    maintainers = with lib.maintainers; [
      bobby285271
    ];
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
  };
})
