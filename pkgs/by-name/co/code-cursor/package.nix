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

  # darwin build
  undmg,
}:
let
  pname = "cursor";
  version = "0.45.14";

  inherit (stdenvNoCC) hostPlatform;

  sources = {
    x86_64-linux = fetchurl {
      url = "https://download.todesktop.com/230313mzl4w4u92/cursor-0.45.14-build-250219jnihavxsz-x86_64.AppImage";
      hash = "sha256-5MGWJi8TP+13jZf6YMMUU5uYY/3OBTFxtGpirvgj8ZI=";
    };
    aarch64-linux = fetchurl {
      url = "https://download.todesktop.com/230313mzl4w4u92/cursor-0.45.14-build-250219jnihavxsz-arm64.AppImage";
      hash = "sha256-8OUlPuPNgqbGe2x7gG+m3n3u6UDvgnVekkjJ08pVORs=";
    };
    x86_64-darwin = fetchurl {
      url = "https://download.todesktop.com/230313mzl4w4u92/Cursor%200.45.14%20-%20Build%20250219jnihavxsz-x64.dmg";
      hash = "sha256-NyDY74PZjSjpuTSVaO/l9adPcLX1kytyrFGQjJ/8WcQ=";
    };
    aarch64-darwin = fetchurl {
      url = "https://download.todesktop.com/230313mzl4w4u92/Cursor%200.45.14%20-%20Build%20250219jnihavxsz-arm64.dmg";
      hash = "sha256-A503TxDDFENqMnc1hy/lMMyIgC7YwwRYPJy+tp649Eg=";
    };
  };

  source = sources.${hostPlatform.system};

  # Linux -- build from AppImage
  appimageContents = appimageTools.extractType2 {
    inherit version pname;
    src = source;

    # Fix the missing keymap issue
    postExtract = ''
      echo $out
      native_keymap="$out/usr/share/cursor/resources/app/node_modules/native-keymap"
      ln -s $native_keymap/build/Release $native_keymap/build/Debug
    '';

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

      # # Replace the supplied libraries with nixpkgs versions
      # rm $out/share/cursor/{libEGL.sl,libffmpeg.so,libGLESv2.so,libvk_swiftshader.so,libvulkan.so.1}
      # ln -s ${egl-wayland}/lib/libEGL.so $out/share/cursor/libEGL.so

      # Fix the desktop file to point to the correct location
      substituteInPlace $out/share/applications/cursor.desktop --replace-fail "/usr/share/cursor/cursor" "$out/share/cursor/cursor"

      wrapProgram $out/bin/cursor \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}} --no-update"
    ''}

    ${lib.optionalString hostPlatform.isDarwin ''
      APP_DIR="$out/Applications"
      CURSOR_APP="$APP_DIR/Cursor.app"
      mkdir -p "$APP_DIR"
      cp -Rp Cursor.app "$APP_DIR"
      mkdir -p "$out/bin"
      cat << EOF > "$out/bin/cursor"
      #!${stdenvNoCC.shell}
      open -na "$CURSOR_APP" --args "\$@"
      EOF
      chmod +x "$out/bin/cursor"
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
      sarahec
      aspauldingcode
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "cursor";
  };
}
