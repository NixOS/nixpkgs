{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nautilus";
  version = "51.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/nautilus/${lib.versions.major finalAttrs.version}/nautilus-${finalAttrs.version}.tar.xz";
    hash = "sha256-pwO8FS0Y0WHZ2rlX4jkKNuYka7XCTeexXJYk/PovKBY=";
  };

  patches = [
    # Allow changing extension directory using environment variable.
    ./extension_dir.patch

    # Required for the next patch to apply
    (fetchpatch {
      name = "remove-unused-headers-in-nautilus-file-operations.patch";
      url = "https://gitlab.gnome.org/GNOME/nautilus/-/commit/d50d83122c512a5b2bbe31f1ca23e1ef2d777182.patch";
      includes = [ "src/nautilus-file-operations.c" ];
      hash = "sha256-JFBAg3TQlt048GxatCYJGtd/AXKQBSOBswFW0aPZm+I=";
    })
    # https://gitlab.gnome.org/GNOME/nautilus/-/merge_requests/2179
    (fetchpatch {
      name = "CVE-2026-111802.patch";
      url = "https://gitlab.gnome.org/GNOME/nautilus/-/commit/0aa4ddabb73287612c3effa3b84955e0afca2e14.patch";
      hash = "sha256-mWRAtldofAzIm/OVocFUC2VnlO3k19xhZeHKN/1pEZ4=";
    })
  ];

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    gi-docgen
    docbook-xsl-nons
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    gexiv2_0_16
    glib-networking
    icu
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
    tinysparql
    localsearch
    gnome-autoar
    libglycin
    libglycin-gtk4
    glycin-loaders
  ];

  propagatedBuildInputs = [
    gtk4
  ];

  mesonFlags = [
    "-Ddocs=true"
    "-Dtests=${if finalAttrs.finalPackage.doCheck then "all" else "none"}"
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

  meta = {
    description = "File manager for GNOME";
    homepage = "https://apps.gnome.org/Nautilus/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.gnome ];
    mainProgram = "nautilus";
  };
})
