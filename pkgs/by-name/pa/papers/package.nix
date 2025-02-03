{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, appstream
, desktop-file-utils
, gtk4
, glib
, pango
, gdk-pixbuf
, shared-mime-info
, itstool
, poppler
, nautilus
, darwin
, djvulibre
, libspectre
, libarchive
, libsecret
, wrapGAppsHook4
, librsvg
, gobject-introspection
, yelp-tools
, gsettings-desktop-schemas
, dbus
, gi-docgen
, libgxps
, withLibsecret ? true
, supportNautilus ? (!stdenv.isDarwin)
, libadwaita
, exempi
, cargo
, rustPlatform
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "papers";
  version = "46.2";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME/Incubator";
    repo = "papers";
    rev = finalAttrs.version;
    hash = "sha256-T67d7xHK23CvmT8omEqNZrV5KloK4QXU973dtP9lTDE=";
  };

  cargoRoot = "shell-rs";

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;

    outputHashes = {
      "cairo-rs-0.20.0" = "sha256-us8Q1cqHbs0wSfMcRgZx7wTqSagYkLv/aNI8Fle2nNk=";
      "gdk4-0.9.0" = "sha256-a+fkiCilKbq7sBHZ9Uvq9a/qqbsVomxG6K07B5f4eYM=";
      "libadwaita-0.7.0" = "sha256-gfkaj/BIqvWj1UNVAGNNXww4aoJPlqvBwIRGmDiv48E=";
    };
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
    libgxps
    librsvg
    libspectre
    pango
    poppler
  ] ++ lib.optionals withLibsecret [
    libsecret
  ] ++ lib.optionals supportNautilus [
    nautilus
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  mesonFlags = [
    "-Dps=enabled"
  ] ++ lib.optionals (!withLibsecret) [
    "-Dkeyring=disabled"
  ] ++ lib.optionals (!supportNautilus) [
    "-Dnautilus=false"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "16"
  ) "-Wno-error=incompatible-function-pointer-types";

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
      # Required to open multiple files.
      # https://gitlab.gnome.org/GNOME/Incubator/papers/-/issues/176
      --prefix PATH : "$out/bin"
    )
  '' + lib.optionalString stdenv.isDarwin ''
    install_name_tool -add_rpath "$out/lib" "$out/bin/papers"
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/papers";
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
