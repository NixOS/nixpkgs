{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  wrapGAppsHook3,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,

  # Runtime dependencies (dlopen'd via purego)
  alsa-lib,
  at-spi2-core,
  cairo,
  fontconfig,
  gdk-pixbuf,
  glib,
  glib-networking,
  gsettings-desktop-schemas,
  gtk-layer-shell,
  gtk3,
  harfbuzz,
  libayatana-appindicator,
  libdbusmenu-gtk3,
  libepoxy,
  libpulseaudio,
  libsecret,
  libsoup_3,
  libx11,
  pango,
  wayland,
  webkitgtk_4_1,
}:

let
  # The MyGo framework loads these libraries with dlopen (via purego) at
  # runtime, so nothing links against them at build time: the wrapper puts
  # them on LD_LIBRARY_PATH.
  #
  # - stdenv.cc.cc.lib: libstdc++.so.6 and libgcc_s.so.1 needed by sherpa-onnx /
  #   onnxruntime prebuilts downloaded at runtime for podcast captions.
  # - alsa-lib: libasound.so.2 (ALSA audio output)
  # - at-spi2-core: libatk-1.0.so.0 (accessibility support)
  # - cairo: libcairo.so.2 (2D graphics rendering)
  # - fontconfig: libfontconfig.so.1 (font configuration and matching)
  # - gdk-pixbuf: libgdk_pixbuf-2.0.so.0 (image loading)
  # - glib: libglib-2.0.so.0, libgobject-2.0.so.0, libgio-2.0.so.0
  # - gtk-layer-shell: libgtk-layer-shell.so.0 (Wayland shell integration)
  # - gtk3: libgtk-3.so.0, libgdk-3.so.0 (windowing and GUI toolkit)
  # - harfbuzz: libharfbuzz.so.0 (text shaping)
  # - libayatana-appindicator: libayatana-appindicator3.so.1 (tray icon)
  # - libdbusmenu-gtk3: libdbusmenu-gtk3.so.4 (tray context menu)
  # - libepoxy: libepoxy.so.0 (OpenGL dispatch)
  # - libpulseaudio: libpulse-simple.so.0, libpulse.so.0 (PulseAudio output)
  # - libsecret: libsecret-1.so.0 (credential and secret storage)
  # - libsoup_3: libsoup-3.0.so.0 (HTTP client networking)
  # - libx11: libX11.so.6 (X11 backend support)
  # - pango: libpango-1.0.so.0, libpangocairo-1.0.so.0 (text layout)
  # - wayland: libwayland-client.so.0 (Wayland backend support)
  # - webkitgtk_4_1: libwebkit2gtk-4.1.so.0 (webview component)
  runtimeLibraries = [
    stdenv.cc.cc.lib
    alsa-lib
    at-spi2-core
    cairo
    fontconfig
    gdk-pixbuf
    glib
    gtk-layer-shell
    gtk3
    harfbuzz
    libayatana-appindicator
    libdbusmenu-gtk3
    libepoxy
    libpulseaudio
    libsecret
    libsoup_3
    libx11
    pango
    wayland
    webkitgtk_4_1
  ];
in
buildGoModule (finalAttrs: {
  pname = "mygo-music";
  version = "0.1.21";

  src = fetchFromGitHub {
    owner = "egoist";
    repo = "mygo-music";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bNo12h7OZnJ6330MWspIdnC5Q1ZN+hKjyTG6ApJALis=";
  };

  vendorHash = "sha256-tLLF3QNjZSaZPFt4R+hdS8YsVm9sM17gZvcceTLcZz4=";

  __structuredAttrs = true;

  # The app is the root package; its tests live in internal/.
  subPackages = [
    "."
    "internal/..."
  ];

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/egoist/mygo.packageName=MyGo Music'"
    "-X github.com/egoist/mygo.packageVersion=${finalAttrs.version}"
    "-X github.com/egoist/mygo.packageIdentifier=dev.egoist.music"
    "-X github.com/egoist/mygo.packageURLSchemes=mygo-music"
    "-X github.com/egoist/mygo.production=1"
  ];

  # `mygo build` drops the devtools inspector from production builds.
  tags = [ "mygo_noinspector" ];

  nativeBuildInputs = [
    copyDesktopItems
    wrapGAppsHook3
  ];

  buildInputs = runtimeLibraries ++ [
    glib-networking
    gsettings-desktop-schemas
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibraries}"
    )
  '';

  postInstall = ''
    install -Dm644 resources/icon.png $out/share/icons/hicolor/1024x1024/apps/mygo-music.png
    install -Dm644 resources/icon.png $out/share/pixmaps/mygo-music.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "mygo-music";
      desktopName = "MyGo Music";
      comment = "A music player for your files and more";
      exec = "mygo-music %U";
      icon = "mygo-music";
      categories = [
        "AudioVideo"
        "Audio"
        "Player"
      ];
      startupWMClass = "mygo-music";
      mimeTypes = [ "x-scheme-handler/mygo-music" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Music player for your files and more";
    homepage = "https://music.egoist.dev";
    changelog = "https://github.com/egoist/mygo-music/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "mygo-music";
    maintainers = with lib.maintainers; [ r0k1s-i ];
    # The MyGo framework only implements its Linux backend for amd64 and arm64.
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
