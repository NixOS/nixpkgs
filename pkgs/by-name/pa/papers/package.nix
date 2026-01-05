{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  appstream,
  blueprint-compiler,
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
  _experimental-update-script-combinators,
  common-updater-scripts,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "papers";
  version = "49.2";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/papers/${lib.versions.major finalAttrs.version}/papers-${finalAttrs.version}.tar.xz";
    hash = "sha256-SanKL2LFWY+ObKTmfIf09ZxewN5wTTspnVFkyR0fakE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      src
      pname
      version
      ;
    hash = "sha256-aOVPknBqBV7AWO9LxvWRjiL2H2UQHAcpGpKY5YeoQrc=";
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
    blueprint-compiler
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
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

  # For https://gitlab.gnome.org/GNOME/papers/-/blob/5efed8638dd4a2d5c36f59eb9a22158d69632e0b/shell/src/meson.build#L36
  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  postPatch = ''
    substituteInPlace shell/src/meson.build thumbnailer/meson.build --replace-fail \
      "meson.current_build_dir() / rust_target / meson.project_name()" \
      "meson.current_build_dir() / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name()"
  '';

  postInstall = ''
    substituteInPlace $out/share/thumbnailers/papers.thumbnailer \
      --replace-fail '=papers-thumbnailer' "=$out/bin/papers-thumbnailer"
  '';

  preFixup = ''
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

  passthru = {
    updateScript =
      let
        updateSource = gnome.updateScript {
          packageName = "papers";
        };

        updateLockfile = {
          command = [
            "sh"
            "-c"
            ''
              PATH=${
                lib.makeBinPath [
                  common-updater-scripts
                ]
              }
              update-source-version papers --ignore-same-version --source-key=cargoDeps.vendorStaging > /dev/null
            ''
          ];
          # Experimental feature: do not copy!
          supportedFeatures = [ "silent" ];
        };
      in
      _experimental-update-script-combinators.sequence [
        updateSource
        updateLockfile
      ];
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/papers";
    changelog = "https://gitlab.gnome.org/GNOME/papers/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
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
