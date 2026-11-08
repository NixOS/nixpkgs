{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gi-docgen,
  docbook-xsl-nons,
  gettext,
  blueprint-compiler,
  desktop-file-utils,
  wayland-scanner,
  wrapGAppsHook4,
  gtk4,
  libadwaita,
  libportal-gtk4,
  gnome,
  adwaita-icon-theme,
  gnome-autoar,
  glib-networking,
  icu,
  shared-mime-info,
  libnotify,
  libexif,
  libglycin,
  libglycin-gtk4,
  libjxl,
  libseccomp,
  librsvg,
  webp-pixbuf-loader,
  tinysparql,
  localsearch,
  gexiv2_0_16,
  libselinux,
  libcloudproviders,
  gdk-pixbuf,
  gnome-desktop,
  gst_all_1,
  gsettings-desktop-schemas,
  gnome-user-share,
  gobject-introspection,
  glycin-loaders,
  withMinimal ? false,
  withSelinux ? !withMinimal,
  withCloudproviders ? !withMinimal,
  withExtensions ? !withMinimal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nautilus";
  version = "51.0.1";

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withExtensions [
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/nautilus/${lib.versions.major finalAttrs.version}/nautilus-${finalAttrs.version}.tar.xz";
    hash = "sha256-oA25CP1lAmy9XcY04S0YnejrorA/EF0kJTQXaKXukvs=";
  };

  patches = [
    # Allow changing extension directory using environment variable.
    ./extension_dir.patch
  ];

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    wayland-scanner
    wrapGAppsHook4
  ]
  ++ lib.optionals withExtensions [
    gobject-introspection
    gi-docgen
    docbook-xsl-nons
  ];

  buildInputs = [
    icu
    gnome-desktop
    adwaita-icon-theme
    gsettings-desktop-schemas
    gst_all_1.gst-plugins-base
    gtk4
    libadwaita
    libportal-gtk4
    libexif
    libseccomp
    shared-mime-info
    tinysparql
    localsearch
    gnome-autoar
    libglycin
    libglycin-gtk4
    glycin-loaders
  ]
  ++ lib.optionals withExtensions [
    gdk-pixbuf
    gexiv2_0_16
  ]
  ++ lib.optionals withSelinux [
    libselinux
  ]
  ++ lib.optionals withCloudproviders [
    libcloudproviders
  ]
  ++ lib.optionals (!withMinimal) [
    libnotify
    glib-networking
    gnome-user-share
  ];

  propagatedBuildInputs = [
    gtk4
  ];

  mesonFlags = [
    (lib.mesonBool "docs" withExtensions)
    (lib.mesonBool "extensions" withExtensions)
    (lib.mesonBool "introspection" withExtensions)
    (lib.mesonOption "tests" (if finalAttrs.finalPackage.doCheck then "all" else "none"))
    (lib.mesonEnable "selinux" withSelinux)
    (lib.mesonEnable "cloudproviders" withCloudproviders)
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${libjxl}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      --prefix XDG_DATA_DIRS : "${webp-pixbuf-loader}/share"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  postFixup = lib.optionalString withExtensions ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "nautilus";
    };
  };

  meta = {
    description = "File manager for GNOME";
    homepage = "https://apps.gnome.org/Nautilus/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.gnome ];
    mainProgram = "nautilus";
  };
})
