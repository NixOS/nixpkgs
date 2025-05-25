{
  lib,
  stdenvNoCC,
  fetchurl,

  # build
  appimageTools,

  # linux dependencies
  alsa-lib,
  at-spi2-atk,
  autoPatchelfHook,
  cairo,
  cups,
  curlWithGnuTls,
  egl-wayland,
  expat,
  fontconfig,
  freetype,
  ffmpeg,
  glib,
  glibc,
  glibcLocales,
  gtk3,
  libappindicator-gtk3,
  libdrm,
  libgbm,
  libGL,
  libnotify,
  libva-minimal,
  libxkbcommon,
  libxkbfile,
  makeWrapper,
  nspr,
  nss,
  pango,
  pciutils,
  pulseaudio,
  vivaldi-ffmpeg-codecs,
  vulkan-loader,
  wayland,

  # linux installation
  rsync,
  commandLineArgs ? "",

  # darwin build
  undmg,
}:
let
  pname = "cursor";
  version = "0.49.6";

  inherit (stdenvNoCC) hostPlatform;

  sources = {
    x86_64-linux = fetchurl {
      url = "https://downloads.cursor.com/production/0781e811de386a0c5bcb07ceb259df8ff8246a52/linux/x64/Cursor-0.49.6-x86_64.AppImage";
      hash = "sha256-WH4/Zw0VJmRGyRzMlkThkhZ4fGysMKBUSIPCTsyGS4w=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/production/0781e811de386a0c5bcb07ceb259df8ff8246a52/linux/arm64/Cursor-0.49.6-aarch64.AppImage";
      hash = "sha256-cpNoff6mDRkT2RicaDlxzqVP9BNe6UEGgJVHr1xMiv0=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/production/0781e811de386a0c5bcb07ceb259df8ff8246a52/darwin/x64/Cursor-darwin-x64.dmg";
      hash = "sha256-fAaLY9YTIuNThFl5OsIMHavy2xwDgYooL4xTSp4Cwzw=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/production/0781e811de386a0c5bcb07ceb259df8ff8246a52/darwin/arm64/Cursor-darwin-arm64.dmg";
      hash = "sha256-DNN2+gfs9u0tZmh75J258d2TL6ErIYludMgPJZcgfb8=";
    };
  };

  source = sources.${hostPlatform.system};

  # Linux -- build from AppImage
  appimageContents = appimageTools.extractType2 {
    inherit version pname;
    src = source;
  };

  wrappedAppimage = appimageTools.wrapType2 {
    inherit version pname;
    src = source;
  };

in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = if hostPlatform.isLinux then wrappedAppimage else source;

  nativeBuildInputs =
    lib.optionals hostPlatform.isLinux [
      autoPatchelfHook
      glibcLocales
      makeWrapper
      rsync
    ]
    ++ lib.optionals hostPlatform.isDarwin [ undmg ];

  buildInputs = lib.optionals hostPlatform.isLinux [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    curlWithGnuTls
    egl-wayland
    expat
    ffmpeg
    glib
    gtk3
    libdrm
    libgbm
    libGL
    libva-minimal
    libxkbcommon
    libxkbfile
    nspr
    nss
    pango
    pulseaudio
    vivaldi-ffmpeg-codecs
    vulkan-loader
    wayland
  ];

  runtimeDependencies = lib.optionals hostPlatform.isLinux [
    egl-wayland
    ffmpeg
    glibc
    libappindicator-gtk3
    libnotify
    libxkbfile
    pciutils
    pulseaudio
    wayland
    fontconfig
    freetype
  ];

  sourceRoot = lib.optionalString hostPlatform.isDarwin ".";

  # Don't break code signing
  dontUpdateAutotoolsGnuConfigScripts = hostPlatform.isDarwin;
  dontConfigure = hostPlatform.isDarwin;
  dontFixup = hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/

    ${lib.optionalString hostPlatform.isLinux ''
      cp -r bin $out/bin
      # mkdir -p $out/share/cursor
      # cp -ar ${appimageContents}/usr/share $out/

      rsync -a -q ${appimageContents}/usr/share $out/ --exclude "*.so"

      # Fix the desktop file to point to the correct location
      substituteInPlace $out/share/applications/cursor.desktop --replace-fail "/usr/share/cursor/cursor" "$out/bin/cursor"

      wrapProgram $out/bin/cursor \
        --add-flags "--update=false" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}} --no-update" \
        --add-flags ${lib.escapeShellArg commandLineArgs}
    ''}

    ${lib.optionalString hostPlatform.isDarwin ''
      APP_DIR="$out/Applications"
      mkdir -p "$APP_DIR"
      cp -Rp Cursor.app "$APP_DIR"
      mkdir -p "$out/bin"
      ln -s "$APP_DIR/Cursor.app/Contents/Resources/app/bin/cursor" "$out/bin/cursor"
    ''}

    runHook postInstall
  '';

  passthru = {
    inherit sources;
    updateScript = ./update.sh;
  };

  meta = {
    description = "AI-powered code editor built on vscode";
    homepage = "https://cursor.com";
    changelog = "https://cursor.com/changelog";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      aspauldingcode
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "cursor";
  };
}
