{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  appstream,
  desktop-file-utils,
  gtk4,
  glib,
  pango,
  gdk-pixbuf,
  shared-mime-info,
  itstool,
  poppler,
  nautilus,
  djvulibre,
  libarchive,
  libsecret,
  wrapGAppsHook4,
  librsvg,
  gobject-introspection,
  yelp-tools,
  gsettings-desktop-schemas,
  dbus,
  gi-docgen,
  libsysprof-capture,
  libspelling,
  withLibsecret ? true,
  supportNautilus ? (!stdenv.hostPlatform.isDarwin),
  libadwaita,
  exempi,
  cargo,
  rustPlatform,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "papers";
  version = "48.4";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/papers/${lib.versions.major finalAttrs.version}/papers-${finalAttrs.version}.tar.xz";
    hash = "sha256-8RqhxUSsIRJZ4jC0DIBK5kB3M5pXve+j2761f5Fm4/0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      src
      pname
      version
      ;
    hash = "sha256-1HFecOTn84m9lT166HlmYjqP+KN/ZOTWW4ztigrpqNQ=";
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    gobject-introspection
    gi-docgen
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    yelp-tools
    cargo
    rustPlatform.cargoSetupHook
  ];

  buildInputs =
    [
      dbus # only needed to find the service directory
      djvulibre
      exempi
      gdk-pixbuf
      glib
      gtk4
      gsettings-desktop-schemas
      libadwaita
      libarchive
      librsvg
      libsysprof-capture
      libspelling
      pango
      poppler
    ]
    ++ lib.optionals withLibsecret [
      libsecret
    ]
    ++ lib.optionals supportNautilus [
      nautilus
    ];

  mesonFlags =
    lib.optionals (!withLibsecret) [
      "-Dkeyring=disabled"
    ]
    ++ lib.optionals (!supportNautilus) [
      "-Dnautilus=false"
    ];

  postInstall = ''
    substituteInPlace $out/share/thumbnailers/papers.thumbnailer \
      --replace-fail '=papers-thumbnailer' "=$out/bin/papers-thumbnailer"
  '';

  preFixup =
    ''
      gappsWrapperArgs+=(
        --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
      )
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      install_name_tool -add_rpath "$out/lib" "$out/bin/papers"
    '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/papers";
    changelog = "https://gitlab.gnome.org/GNOME/Incubator/papers/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "GNOME's document viewer";

    longDescription = ''
      papers is a document viewer for multiple document formats.  It
      currently supports PDF, PostScript, DjVu, and TIFF (not DVI anymore).
      The goal of papers is to replace the evince document viewer that exist
      on the GNOME Desktop with a more modern interface.
    '';

    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    mainProgram = "papers";
    teams = [ teams.gnome ];
  };
})
