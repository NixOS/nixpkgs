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

stdenv.mkDerivation rec {
  pname = "libgedit-tepl";
  version = "6.13.0";

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
    tag = version;
    hash = "sha256-YWONsw5+gq5Uew6xB76pKsGTJmI83zAssO5WX6aP7ZM=";
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

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/gedit/libgedit-tepl";
    description = "Text editor product line";
    maintainers = with maintainers; [
      manveru
      bobby285271
    ];
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
  };
}
