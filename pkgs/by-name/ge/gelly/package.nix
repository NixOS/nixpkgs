{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  glib,
  wrapGAppsHook4,
  glib-networking,
  gstreamer,
  gst-plugins-ugly,
  gst-plugins-rs,
  gst-plugins-good,
  gst-plugins-base,
  gst-plugins-bad,
  gtk4,
  libadwaita,
  libseccomp,
  openssl,
  bubblewrap,
  glycin-loaders,
  nix-update-script,
  aws-lc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gelly";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "Fingel";
    repo = "gelly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yzZ8rHm7NHvleLs63b9BKST1VrLDOL3nfmjdNAHjLMo=";
  };

  cargoHash = "sha256-wUEya5nNFtEt4yQ9oS9fbgtUoIFwdCXIUZ7Rf7uZBTU=";

  nativeBuildInputs = [
    pkg-config
    glib # for `glib-compile-schemas` and `glib-compile-resources` (used in upstream's `build.rs`)
    wrapGAppsHook4
  ];

  buildInputs = [
    dbus
    # Very important, so that gstreamer supports TLS
    glib-networking
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-plugins-rs
    gtk4
    libadwaita
    libseccomp
    openssl
    aws-lc
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Jellyfin GTK client for Linux focused on music";
    homepage = "https://github.com/Fingel/gelly";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ minijackson ];
    mainProgram = "gelly";
    platforms = lib.platforms.linux;
  };
})
