{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
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
  darwin,
  djvulibre,
  libspectre,
  libarchive,
  libsecret,
  wrapGAppsHook4,
  librsvg,
  gobject-introspection,
  yelp-tools,
  gsettings-desktop-schemas,
  dbus,
  gi-docgen,
  libgxps,
  withLibsecret ? true,
  supportNautilus ? (!stdenv.hostPlatform.isDarwin),
  libadwaita,
  exempi,
  cargo,
  rustPlatform,
  rustfmt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "papers";
  version = "47.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/papers/${lib.versions.major finalAttrs.version}/papers-${finalAttrs.version}.tar.xz";
    hash = "sha256-z2nrCjcX/jVAEWFuL2Ajg4FP9Xt6nqzzBsZ25k2PZmY=";
  };

  # FIXME: remove in next version
  patches = [
    (fetchpatch {
      name = "fix-crash-when-drag-and-drop";
      url = "https://gitlab.gnome.org/GNOME/Incubator/papers/-/commit/455ad2aebe5e5d5a57a2f4defc6af054927eac73.patch";
      hash = "sha256-PeWlFhvM8UzUFRaK9k/9Txwgta/EiFnMRjHwld3O+cU=";
    })
  ];

  cargoRoot = "shell-rs";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs)
      src
      pname
      version
      cargoRoot
      ;
    hash = "sha256-/5IySNEUkwiQezLx4n4jlPJdqJhlcgt5bXIelUFftZI=";
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
    # FIXME: remove rustfmt in next version
    # https://gitlab.gnome.org/GNOME/Incubator/papers/-/commit/d0093c8c9cbacfbdafd70b6024982638b30a2591
    rustfmt
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
      libgxps
      librsvg
      libspectre
      pango
      poppler
    ]
    ++ lib.optionals withLibsecret [
      libsecret
    ]
    ++ lib.optionals supportNautilus [
      nautilus
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Foundation
    ];

  mesonFlags =
    [
      "-Dps=enabled"
    ]
    ++ lib.optionals (!withLibsecret) [
      "-Dkeyring=disabled"
    ]
    ++ lib.optionals (!supportNautilus) [
      "-Dnautilus=false"
    ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "16"
  ) "-Wno-error=incompatible-function-pointer-types";

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
    maintainers = teams.gnome.members;
  };
})
