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
, atk
, gdk-pixbuf
, shared-mime-info
, itstool
, poppler
, ghostscriptX
, djvulibre
, libspectre
, libarchive
, libsecret
, wrapGAppsHook
, librsvg
, gobject-introspection
, yelp-tools
, gspell
, gsettings-desktop-schemas
, dbus
, gst_all_1
, gi-docgen
, supportMultimedia ? true # PDF multimedia
, libgxps
, supportXPS ? true # Open XML Paper Specification via libgxps
, withLibsecret ? true
, libadwaita
, exempi
, cargo
, rustPlatform
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "papers";
  version = "45.0-unstable-2024-03-27";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME/Incubator";
    repo = "papers";
    rev = "4374535f4f5e5cea613b2df7b3dc99e97da27d99";
    hash = "sha256-wjLRGENJ+TjXV3JPn/lcqv3DonAsJrC0OiLs1DoNHkc=";
  };

  cargoRoot = "shell-rs";

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;

    outputHashes = {
      "cairo-rs-0.20.0" = "sha256-aCG9rh/tXqmcCIijuqJZJEgrGdG/IygcdWlvKYzVPhU=";
      "gdk4-0.9.0" = "sha256-KYisC8nm6KVfowiKXtMoimXzB3UjHarH+2ZLhvW8oMU=";
      "libadwaita-0.7.0" = "sha256-gfkaj/BIqvWj1UNVAGNNXww4aoJPlqvBwIRGmDiv48E=";
    };
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    gobject-introspection
    gi-docgen
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook
    yelp-tools
    cargo
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    atk
    dbus # only needed to find the service directory
    djvulibre
    gdk-pixbuf
    ghostscriptX
    glib
    gtk4
    gsettings-desktop-schemas
    gspell
    libarchive
    librsvg
    libspectre
    pango
    poppler
  ] ++ lib.optionals withLibsecret [
    libsecret
  ] ++ lib.optionals supportXPS [
    libgxps
  ] ++ lib.optionals supportMultimedia (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
    libadwaita
    exempi
  ]);

  mesonFlags = [
    "-Dnautilus=false"
    "-Dps=enabled"
  ] ++ lib.optionals (!withLibsecret) [
    "-Dkeyring=disabled"
  ] ++ lib.optionals (!supportMultimedia) [
    "-Dmultimedia=disabled"
  ];

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share")
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
    maintainers = teams.gnome.members ++ teams.pantheon.members;
  };
})
