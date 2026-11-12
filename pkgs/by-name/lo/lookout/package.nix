{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  glib-networking,
  gst_all_1,
  gtk3,
  gdk-pixbuf,
  libayatana-appindicator,
  libclang,
  libgbm,
  librsvg,
  sqlite,
  libxkbcommon,
  libx11,
  libxrandr,
  libxcb,
  openssl,
  pipewire,
  pkg-config,
  wrapGAppsHook4,
  webkitgtk_4_1,
  vulkan-loader,
  wayland,
  libglvnd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lookout";
  version = "0.4.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hackclub";
    repo = "lookout";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nLTPchUIKnXosw/pKJnITrzdJLGbbabgqKK4vgsqEbY=";
  };

  patches = [ ./remove-updater.patch ];

  cargoRoot = "clients/native";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-I21uYvRICUW4uvp32s4xXcDbA2zJk0g0tqDawXxZfcM=";
  cargoBuildFlags = [
    "-p"
    "lookout-native"
  ];
  cargoTestFlags = [
    "-p"
    "lookout-native"
  ];

  nativeBuildInputs = [
    pkg-config
    libclang.lib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  env = {
    LIBCLANG_PATH = "${libclang.lib}/lib";
    BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${stdenv.cc.libc.dev}/include -isystem ${libclang.lib}/lib/clang/${lib.versions.major libclang.version}/include";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
    gtk3
    gdk-pixbuf
    libayatana-appindicator
    libgbm
    librsvg
    openssl
    pipewire
    webkitgtk_4_1
    sqlite
    vulkan-loader
    wayland
    libx11
    libxrandr
    libxcb
    libxkbcommon
  ];

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          vulkan-loader
          wayland
          libxkbcommon
          libglvnd
          libx11
          libxcb
        ]
      }"
    )
  '';

  postInstall = ''
    install -Dm644 clients/native/packaging/linux/com.hackclub.lookout.desktop $out/share/applications/com.hackclub.lookout.desktop
    install -Dm644 clients/native/assets/app-icon.png $out/share/icons/hicolor/128x128/apps/com.hackclub.lookout.png
    substituteInPlace $out/share/applications/com.hackclub.lookout.desktop \
      --replace "Exec=lookout" "Exec=$out/bin/lookout"
  '';

  meta = {
    description = "Hack Club time-tracking desktop app that captures periodic screenshots";
    homepage = "https://github.com/hackclub/lookout";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ cloudglides ];
    platforms = lib.platforms.linux;
    mainProgram = "lookout";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
