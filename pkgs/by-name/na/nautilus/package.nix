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
  desktop-file-utils,
  wrapGAppsHook4,
  gtk4,
  libadwaita,
  libportal-gtk4,
  gnome,
  adwaita-icon-theme,
  gnome-autoar,
  glib-networking,
  shared-mime-info,
  libnotify,
  libexif,
  libjxl,
  libseccomp,
  librsvg,
  webp-pixbuf-loader,
  tracker,
  tracker-miners,
  gexiv2,
  libselinux,
  libcloudproviders,
  gdk-pixbuf,
  substituteAll,
  gnome-desktop,
  gst_all_1,
  gsettings-desktop-schemas,
  gnome-user-share,
  gobject-introspection,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nautilus";
  version = "46.2";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/nautilus/${lib.versions.major finalAttrs.version}/nautilus-${finalAttrs.version}.tar.xz";
    hash = "sha256-bujJkBm540R/aRjWgjKiDeyonlUlwFgFQyt9iEDKcfo=";
  };

  patches = [
    # Allow changing extension directory using environment variable.
    ./extension_dir.patch

    # Hardcode required paths.
    (substituteAll {
      src = ./fix-paths.patch;
      inherit tracker;
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    gi-docgen
    docbook-xsl-nons
    wrapGAppsHook4
  ];

  buildInputs = [
    gexiv2
    glib-networking
    gnome-desktop
    adwaita-icon-theme
    gsettings-desktop-schemas
    gnome-user-share
    gst_all_1.gst-plugins-base
    gtk4
    libadwaita
    libportal-gtk4
    libexif
    libnotify
    libseccomp
    libselinux
    gdk-pixbuf
    libcloudproviders
    shared-mime-info
    tracker
    tracker-miners
    gnome-autoar
  ];

  propagatedBuildInputs = [
    gtk4
  ];

  mesonFlags = [
    "-Ddocs=true"
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

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "nautilus";
    };
  };

  meta = with lib; {
    description = "File manager for GNOME";
    homepage = "https://apps.gnome.org/Nautilus/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
    mainProgram = "nautilus";
  };
})
