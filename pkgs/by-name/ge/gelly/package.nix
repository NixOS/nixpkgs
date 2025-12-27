{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  glib,
  wrapGAppsHook4,
  glib-networking,
  gst_all_1,
  gtk4,
  libadwaita,
  libseccomp,
  openssl,
  bubblewrap,
  glycin-loaders,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gelly";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "Fingel";
    repo = "gelly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0iqBAwSWcYJyu7YbFvlSzGvRKYAXyDzDzy0yWjL4eu0=";
  };

  cargoHash = "sha256-1bPmSz20UOAGvIbWwsB6BoNxXcOxg+f0dpnLw3V80CM=";

  nativeBuildInputs = [
    pkg-config
    glib # for `glib-compile-schemas` and `glib-compile-resources` (used in upstream's `build.rs`)
    wrapGAppsHook4
  ];

  buildInputs = [
    dbus
    # Very important, so that gstreamer supports TLS
    glib-networking
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-rs
    gtk4
    libadwaita
    libseccomp
    openssl
  ];

  # Adapted from upstream's `justfile`
  postInstall = ''
    install -Dm644 resources/io.m51.Gelly.desktop $out/share/applications/io.m51.Gelly.desktop
    install -Dm644 resources/io.m51.Gelly.metainfo.xml $out/share/metainfo/io.m51.Gelly.metainfo.xml
    install -Dm644 resources/io.m51.Gelly.svg $out/share/icons/hicolor/scalable/apps/io.m51.Gelly.svg

    # Use the gschemas location as specified in the glib hook
    install -Dm644 resources/io.m51.Gelly.gschema.xml $out/share/gsettings-schemas/$name/glib-2.0/schemas/io.m51.Gelly.gschema.xml
    glib-compile-schemas $out/share/gsettings-schemas/$name/glib-2.0/schemas/
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "$out/bin:${lib.makeBinPath [ bubblewrap ]}"
      --prefix XDG_DATA_DIRS : "${glycin-loaders}/share"
    )
  '';

  meta = {
    description = "A Jellyfin GTK client for Linux focused on music";
    homepage = "https://github.com/Fingel/gelly";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ minijackson ];
    mainProgram = "gelly";
    platforms = lib.platforms.linux;
  };
})
