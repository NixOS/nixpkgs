{
  stdenv,
  lib,
  cmark,
  editorconfig-core-c,
  fetchurl,
  flatpak,
  gi-docgen,
  glib,
  gnome,
  gobject-introspection,
  gom,
  gtk4,
  gtksourceview5,
  json-glib,
  libdex,
  libgit2,
  libpeas2,
  libsoup_3,
  libspelling,
  libssh2,
  libsysprof-capture,
  libxml2,
  libyaml,
  meson,
  ninja,
  pkg-config,
  template-glib,
  vte-gtk4,
  webkitgtk_6_0,
  wrapGAppsNoGuiHook,
  withGtk ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfoundry${lib.optionalString withGtk "-gtk"}";
  version = "1.0.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/foundry/${lib.versions.majorMinor finalAttrs.version}/foundry-${finalAttrs.version}.tar.xz";
    hash = "sha256-wHaJBv6zTdWBmeKFRHOeohe714g+WPJPEjIphryJkzk=";
  };

  patches = [
    ./host_sdk_filename_nixos.patch
  ];

  nativeBuildInputs = [
    gi-docgen
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    editorconfig-core-c
    flatpak
    gom
    libgit2
    libsoup_3
    libssh2
    libsysprof-capture
    libxml2
    libyaml
    template-glib
  ]
  ++ lib.optionals withGtk [
    cmark
    gtk4
    gtksourceview5
    libspelling
    vte-gtk4
    webkitgtk_6_0
  ];

  propagatedBuildInputs = [
    glib
    json-glib
    libdex
    libpeas2
  ];

  strictDeps = true;

  mesonFlags = [
    (lib.mesonBool "docs" true)
    (lib.mesonBool "gtk" withGtk)
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru.updateScript = gnome.updateScript {
    packageName = "foundry";
    attrPath = "libfoundry";
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
