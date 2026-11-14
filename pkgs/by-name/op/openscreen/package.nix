{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  callPackage,
  copyDesktopItems,
  makeWrapper,
  makeDesktopItem,
  electron_43,
  nodejs_22,
  ffmpeg,
  ffmpeg-headless,
  mesa,
  intel-media-driver,
  intel-vaapi-driver,
  nix-update-script,
}:
let
  electron = electron_43;
  nodejs = nodejs_22;

  version = "2.2.2";
  src = fetchFromGitHub {
    owner = "getopenscreen";
    repo = "openscreen";
    tag = "v${version}";
    hash = "sha256-t0x5wXtaRS/ZYrHnoGqSP7mgM2GO0psPGTpB3AamGd4=";
  };

  # H.264 through openh264, without GPL x264: the app is MIT and upstream ships an LGPL ffmpeg.
  ffmpeg-lgpl = ffmpeg.override {
    withOpenh264 = true;
    withGPL = false;
  };
  native = { inherit version src ffmpeg-lgpl; };
  compositor-view = callPackage ./compositor-view.nix native;
  pipewire-helper = callPackage ./pipewire-helper.nix native;
  whisper-stt = callPackage ./whisper-stt.nix { inherit version src; };

  # The only ffmpeg CLI call decodes audio to raw PCM.
  ffmpegCli = ffmpeg-headless.override { withGPL = false; };

  vaDriversPath = lib.makeSearchPath "lib/dri" (
    [ mesa ]
    ++ lib.optionals stdenv.hostPlatform.isx86_64 [
      intel-media-driver
      intel-vaapi-driver
    ]
  );
in
buildNpmPackage {
  inherit nodejs version src;
  pname = "openscreen";

  npmDepsHash = "sha256-kqvXt9uwinx/HQBkwbPG7PMCUtqMgeZKOYFsmwox3cw=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  npmFlags = [ "--ignore-scripts" ];
  makeCacheWritable = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  # vite-plugin-electron builds both the renderer (dist/) and the main process (dist-electron/).
  buildPhase = ''
    runHook preBuild
    npm exec vite build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/openscreen
    cp -r dist dist-electron package.json $out/share/openscreen/
    npm prune --omit=dev --no-save
    cp -r node_modules $out/share/openscreen/
    # The app resolves its assets at <appPath>/public; vite copied public/ into dist/.
    ln -s dist $out/share/openscreen/public

    makeWrapper ${lib.getExe electron} $out/bin/openscreen \
      --add-flags $out/share/openscreen \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --suffix LIBVA_DRIVERS_PATH : "/run/opengl-driver/lib/dri:${vaDriversPath}" \
      --set OPENSCREEN_FFMPEG_PATH ${lib.getExe ffmpegCli} \
      --set OPENSCREEN_COMPOSITOR_VIEW_NODE ${compositor-view}/lib/compositor_view.node \
      --set OPENSCREEN_LINUX_CURSOR_HELPER_EXE ${lib.getExe pipewire-helper} \
      --set OPENSCREEN_WHISPER_SERVER_EXE ${lib.getExe whisper-stt} \
      --inherit-argv0

    for size in 16 24 32 48 64 128 256 512 1024; do
      icon=icons/icons/png/''${size}x''${size}.png
      if [ -f $icon ]; then
        install -Dm644 $icon $out/share/icons/hicolor/''${size}x''${size}/apps/openscreen.png
      fi
    done

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "openscreen";
      desktopName = "OpenScreen";
      genericName = "Screen Recorder";
      comment = "Desktop screen recorder with built-in editor";
      icon = "openscreen";
      exec = "openscreen %U";
      categories = [
        "AudioVideo"
        "Video"
        "Recorder"
      ];
      startupWMClass = "Openscreen";
      terminal = false;
    })
  ];

  passthru = {
    inherit compositor-view pipewire-helper whisper-stt;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Desktop screen recorder with built-in editor";
    homepage = "https://github.com/getopenscreen/openscreen";
    changelog = "https://github.com/getopenscreen/openscreen/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      etiennelescot
    ];
    mainProgram = "openscreen";
    # The native parts (compositor addon, PipeWire helper) are packaged for Linux only.
    platforms = lib.platforms.linux;
  };
}
