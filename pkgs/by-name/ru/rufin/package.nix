{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cacert,
  glib,
  gettext,
  gst_all_1,
  gtk4,
  libadwaita,
  pkg-config,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rufin";
  version = "0.12.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "screwys";
    repo = "Rufin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QOlDZAVjDgAV1G4+f82TpNbyv+96QGDAUqf5r+A4PuU=";
  };

  cargoHash = "sha256-6u23YZSYYYAcnoOOZiCUCy9rbiOS59Nu4hj3WKhL/B0=";

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ]);

  cargoBuildFlags = [
    "-p"
    "rufin"
  ];

  doCheck = false;

  postInstall = ''
    install -Dm644 data/japanese-readings.dic \
      "$out/share/rufin/japanese-readings.dic"
    install -Dm644 data/japanese-readings.LICENSE \
      "$out/share/licenses/rufin/japanese-readings.LICENSE"
    install -Dm644 data/io.github.screwys.Rufin.desktop \
      "$out/share/applications/io.github.screwys.Rufin.desktop"
    substituteInPlace "$out/share/applications/io.github.screwys.Rufin.desktop" \
      --replace-fail "Exec=rufin" "Exec=$out/bin/rufin"
    install -Dm644 data/io.github.screwys.Rufin.metainfo.xml \
      "$out/share/metainfo/io.github.screwys.Rufin.metainfo.xml"
    install -Dm644 data/icons/hicolor/scalable/apps/io.github.screwys.Rufin.svg \
      "$out/share/icons/hicolor/scalable/apps/io.github.screwys.Rufin.svg"
    install -Dm644 -t "$out/share/icons/hicolor/scalable/actions" \
      data/icons/hicolor/scalable/actions/*.svg
    install -Dm644 -t "$out/share/icons/hicolor/scalable/status" \
      data/icons/hicolor/scalable/status/*.svg
    install -Dm644 -t "$out/share/icons/hicolor/512x512/apps" \
      data/icons/hicolor/512x512/apps/*.png
    install -Dm644 -t "$out/share/icons/hicolor/64x64/apps" \
      data/icons/hicolor/64x64/apps/*.png

    for po_file in crates/localization/locales/*.po; do
      if [ -f "$po_file" ]; then
        lang="$(basename "$po_file" .po)"
        mkdir -p "$out/share/locale/$lang/LC_MESSAGES"
        msgfmt "$po_file" -o "$out/share/locale/$lang/LC_MESSAGES/rufin.mo"
      fi
    done
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set-default RUFIN_LOCALEDIR "$out/share/locale"
      --set-default SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt"
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
    )
  '';

  meta = {
    description = "Native GTK4/libadwaita music client for Jellyfin, Subsonic, Navidrome and local libraries written in Rust";
    homepage = "https://github.com/screwys/Rufin";
    changelog = "https://github.com/screwys/Rufin/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ screwys ];
    mainProgram = "rufin";
    platforms = lib.platforms.linux;
  };
})
