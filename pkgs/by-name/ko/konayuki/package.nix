{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  glib,
  desktop-file-utils,
  gtk4,
  libadwaita,
  gst_all_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "konayuki";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Restoration";
    repo = "konayuki";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+baePjjvgZ5lR760CLOMuJ4tf+abL1d+l5ixstXRhfs=";
  };

  cargoHash = "sha256-MgXBQsQEOaO87H21xKOYjnwmXqTqH7giCSRZBb9gzeE=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    glib
    desktop-file-utils
  ];

  buildInputs = [
    gtk4
    libadwaita
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  postInstall = ''
    install -Dm644 data/io.github.Restoration.Konayuki.desktop \
      -t $out/share/applications
    install -Dm644 data/io.github.Restoration.Konayuki.gschema.xml \
      -t $out/share/glib-2.0/schemas
    glib-compile-schemas $out/share/glib-2.0/schemas
    install -Dm644 data/icons/hicolor/scalable/apps/io.github.Restoration.Konayuki.svg \
      -t $out/share/icons/hicolor/scalable/apps
    install -Dm644 data/icons/hicolor/symbolic/apps/io.github.Restoration.Konayuki-symbolic.svg \
      -t $out/share/icons/hicolor/symbolic/apps
  '';

  # The test suite needs a compiled GSettings schema and a GStreamer
  # plugin registry, neither of which exists in the build sandbox.
  preCheck = ''
    export HOME="$TMPDIR"
    export GSETTINGS_SCHEMA_DIR="$TMPDIR/schemas"
    mkdir -p "$GSETTINGS_SCHEMA_DIR"
    cp data/*.gschema.xml "$GSETTINGS_SCHEMA_DIR/"
    glib-compile-schemas "$GSETTINGS_SCHEMA_DIR"
    export GST_PLUGIN_SYSTEM_PATH_1_0="${
      lib.makeSearchPath "lib/gstreamer-1.0" (
        with gst_all_1;
        [
          gstreamer
          gst-plugins-base
          gst-plugins-good
          gst-plugins-bad
        ]
      )
    }"
  '';

  postCheck = ''
    desktop-file-validate data/io.github.Restoration.Konayuki.desktop
  '';

  meta = {
    description = "Small and simple music player";
    homepage = "https://github.com/Restoration/konayuki";
    changelog = "https://github.com/Restoration/konayuki/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    mainProgram = "konayuki";
    maintainers = with lib.maintainers; [ restoration ];
    platforms = lib.platforms.linux;
  };
})
