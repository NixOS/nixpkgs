{
  lib,
  rustPlatform,
  fetchFromGitHub,
  autoPatchelfHook,
  pkg-config,
  cmake,
  makeWrapper,
  alsa-lib-with-plugins,
  alsa-plugins,
  pipewire,
  dbus,
  fontconfig,
  freetype,
  sqlite,
  vulkan-loader,
  wayland,
  libxkbcommon,
  libxcb,
  libx11,
  libxcursor,
  libxi,
  webkitgtk_4_1,
  glib-networking,
  gst_all_1,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sonora";
  version = "0.42.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sonorahq";
    repo = "sonora";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TwKX1lqgZjtBMAkOWV3wcpSkKlnOlnu1hpRB3JNPs94=";
  };

  cargoHash = "sha256-lW3mh9fCNp1kGSmdg/l4AMrxwNZrB9CEORymOZPw+a4=";

  postPatch = ''
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
    cmake
    makeWrapper
  ];

  buildInputs = [
    (alsa-lib-with-plugins.override {
      plugins = [
        alsa-plugins
        pipewire
      ];
    })
    dbus
    fontconfig
    freetype
    sqlite
    libxkbcommon
    libxcb
    libx11
    libxcursor
    libxi
  ];

  runtimeDependencies = [
    vulkan-loader
    wayland
    webkitgtk_4_1
  ];

  env.LIBSQLITE3_SYS_USE_PKG_CONFIG = "1";

  cargoBuildFlags = [ "--package=sonora" ];

  doCheck = false;

  postInstall = ''
    install -Dm644 assets/linux/sonora.desktop $out/share/applications/sonora.desktop
    install -Dm644 assets/linux/sonora.svg $out/share/icons/hicolor/scalable/apps/sonora.svg
    for icon in assets/linux/icons/hicolor/*/apps/sonora.png; do
      size="$(basename "$(dirname "$(dirname "$icon")")")"
      install -Dm644 "$icon" "$out/share/icons/hicolor/$size/apps/sonora.png"
    done
    install -Dm644 COPYING $out/share/licenses/sonora/LICENSE
    install -Dm644 THIRD-PARTY.md $out/share/licenses/sonora/THIRD-PARTY.md
    install -Dm644 assets/fonts/LICENSE.txt $out/share/licenses/sonora/sonora/LICENSE.Inter
    for license in assets/icons/*/LICENSE; do
      pack="$(basename "$(dirname "$license")")"
      install -Dm644 "$license" "$out/share/licenses/sonora/icons/LICENSE.$pack"
    done
    install -Dm644 assets/icons/LICENSE $out/share/licenses/sonora/icons/LICENSE
  '';

  # WebKitGTK needs its TLS and audio modules when the sign-in webview is opened.
  postFixup = ''
    wrapProgram $out/bin/sonora \
      --prefix GIO_EXTRA_MODULES : ${glib-networking}/lib/gio/modules \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ${
        lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (
          with gst_all_1;
          [
            gstreamer
            gst-plugins-base
            gst-plugins-good
          ]
        )
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native music streaming client built with Rust and GPUI";
    homepage = "https://github.com/sonorahq/sonora";
    changelog = "https://github.com/sonorahq/sonora/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3Plus
      ofl
      isc
      mit
      asl20
      cc-by-40
      cc0
    ];
    maintainers = with lib.maintainers; [
      Ra77a3l3-jar
      nolight132
    ];
    mainProgram = "sonora";
    platforms = lib.platforms.linux;
  };
})
