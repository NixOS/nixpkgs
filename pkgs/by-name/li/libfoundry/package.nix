{
  stdenv,
  lib,
  fetchurl,
  gi-docgen,
  wrapGAppsNoGuiHook,
  glib,
  gnome,
  gobject-introspection,
  gom,
  gtk4,
  webkitgtk_6_0,
  libspelling,
  gtksourceview5,
  json-glib,
  libxml2,
  libyaml,
  libgit2,
  libssh2,
  flatpak,
  libsoup_3,
  editorconfig-core-c,
  template-glib,
  libdex,
  libpeas2,
  libsysprof-capture,
  meson,
  ninja,
  pkg-config,
  shared-mime-info,
  vte-gtk4,
  cmark,
  withGtk ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfoundry${lib.optionalString withGtk "-gtk"}";
  version = "1.0.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/foundry/${lib.versions.majorMinor finalAttrs.version}/foundry-${finalAttrs.version}.tar.xz";
    hash = "sha256-WmEsxLqFXBe6jR/rxfgHLpCtavoDZoQ/1SVfGwxz+Xs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    gi-docgen
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    gom
    libxml2
    libyaml
    libgit2
    libssh2
    flatpak
    libsoup_3
    editorconfig-core-c
    template-glib
    libsysprof-capture
  ]
  ++ lib.optionals withGtk [
    vte-gtk4
    cmark
    gtk4
    webkitgtk_6_0
    libspelling
    gtksourceview5
  ];

  propagatedBuildInputs = [
    glib
    libdex
    libpeas2
    json-glib
  ];

  strictDeps = true;

  mesonFlags = [
    (lib.mesonBool "gtk" withGtk)
    (lib.mesonBool "docs" true)
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "foundry";
      attrPath = "libfoundry";
    };
  };

  meta = {
    description = "Command line tool and library that can be used to build developer tools";
    mainProgram = "foundry";
    homepage = "https://gitlab.gnome.org/GNOME/foundry";
    changelog = "https://gitlab.gnome.org/GNOME/foundry/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = lib.licenses.lgpl21Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
})
