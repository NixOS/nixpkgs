{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  gettext,
  itstool,
  pkg-config,
  libxml2,
  libjpeg,
  libpeas,
  libportal-gtk3,
  gnome,
  gtk3,
  libhandy,
  glib,
  gsettings-desktop-schemas,
  gnome-desktop,
  lcms2,
  gdk-pixbuf,
  exempi,
  shared-mime-info,
  wrapGAppsHook3,
  libjxl,
  librsvg,
  webp-pixbuf-loader,
  libheif,
  libexif,
  gobject-introspection,
  gi-docgen,
}:

stdenv.mkDerivation rec {
  pname = "eog";
  version = "47.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/eog/${lib.versions.major version}/eog-${version}.tar.xz";
    hash = "sha256-217b9SJNdRJqe32O5OknKi8wqVMzHVuvbT88DODL3mY=";
  };

  patches = [
    # Fix path to libeog.so in the gir file.
    # We patch gobject-introspection to hardcode absolute paths but
    # our Meson patch will only pass the info when install_dir is absolute as well.
    ./fix-gir-lib-path.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    wrapGAppsHook3
    libxml2 # for xmllint for xml-stripblanks
    gobject-introspection
    gi-docgen
  ];

  buildInputs = [
    libjpeg
    libportal-gtk3
    gtk3
    libhandy
    gdk-pixbuf
    glib
    libpeas
    librsvg
    lcms2
    gnome-desktop
    libexif
    exempi
    gsettings-desktop-schemas
    shared-mime-info
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  postInstall = ''
    # Pull in WebP and JXL support for gnome-backgrounds.
    # In postInstall to run before gappsWrapperArgsHook.
    export GDK_PIXBUF_MODULE_FILE="${
      gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
        extraLoaders = [
          libjxl
          librsvg
          webp-pixbuf-loader
          libheif.out
        ];
      }
    }"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${libjxl}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "eog";
    };
  };

  meta = {
    description = "GNOME image viewer";
    homepage = "https://gitlab.gnome.org/GNOME/eog";
    changelog = "https://gitlab.gnome.org/GNOME/eog/-/blob/${version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.unix;
    mainProgram = "eog";
  };
}
