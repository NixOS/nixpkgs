{
  lib,
  stdenv,
  fetchurl,
  zstd,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  nixosTests,
  # Audio
  alsa-lib,
  libpulseaudio,
  pipewire,
  # GTK/GUI toolkit
  atk,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  pango,
  # Graphics/rendering (Electron/Chromium)
  libdrm,
  libgbm,
  libglvnd,
  # X11
  libX11,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXScrnSaver,
  libXtst,
  libxcb,
  libxshmfence,
  # Wayland
  wayland,
  # System libraries
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  libnotify,
  libuuid,
  systemdLibs,
  # Chromium security (NSS/NSPR)
  nspr,
  nss,
  makeDesktopItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deemix";
  version = "0.4.3";

  src = fetchurl {
    url = "https://github.com/bambanah/deemix/releases/download/deemix-gui%40${finalAttrs.version}/deemix_${finalAttrs.version}_amd64.deb";
    hash = "sha256-rc/ZHbtRY4ceQsb1hvEVnQulvcjKIMLxPpRxlqujNXY=";
  };

  nativeBuildInputs = [
    zstd # Decompress data.tar.zst
    autoPatchelfHook # Automatically patch ELF binaries
    makeWrapper # Create wrapper scripts
    wrapGAppsHook3 # GTK3 application wrapper
  ];

  # Libraries needed at build time for autoPatchelfHook to resolve
  buildInputs = [
    alsa-lib
    cups
    libdrm
    libgbm
    libuuid
    libX11
    libXdamage
    libXScrnSaver
    libXtst
    libxcb
    libxshmfence
    nspr
    nss
  ];

  dontWrapGApps = true;

  # Libraries needed at runtime via LD_LIBRARY_PATH
  # Electron apps dynamically load many libraries not detected by autoPatchelfHook
  libPath = lib.makeLibraryPath [
    # Audio backends
    alsa-lib # ALSA sound
    libpulseaudio # PulseAudio
    pipewire # Modern audio server

    # GTK3 stack for UI rendering
    atk # Accessibility toolkit
    at-spi2-atk # Accessibility bridge
    at-spi2-core # Accessibility core
    cairo # 2D graphics
    gdk-pixbuf # Image loading
    glib # GLib utilities
    gtk3 # GTK3 widgets
    pango # Text rendering

    # Graphics and GPU acceleration
    libdrm # Direct Rendering Manager
    libgbm # Generic Buffer Management
    libglvnd # OpenGL vendor dispatch

    # X11 display server
    libX11 # Core X11
    libXcomposite # Compositing
    libXcursor # Cursor rendering
    libXdamage # Damage tracking
    libXext # X extensions
    libXfixes # X fixes
    libXi # X input
    libXrandr # Resolution/rotation
    libXrender # Render extension
    libXScrnSaver # Screen saver
    libXtst # Testing extension
    libxcb # X protocol C binding
    libxshmfence # Shared memory fences

    # Wayland display server
    wayland

    # System services
    cups # Printing support
    dbus # Inter-process communication
    expat # XML parsing
    fontconfig # Font configuration
    freetype # Font rendering
    libnotify # Desktop notifications
    libuuid # UUID generation
    systemdLibs # systemd integration

    # Chromium security stack
    nspr # Netscape Portable Runtime
    nss # Network Security Services

    # C++ standard library
    stdenv.cc.cc
  ];

  unpackPhase = ''
    runHook preUnpack
    # Extract .deb manually to avoid SUID permission errors on chrome-sandbox
    # Uses user namespaces for sandboxing instead of SUID binary
    ar x $src
    tar --no-same-permissions -xf data.tar.*
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt/deemix,share/pixmaps,share/icons/hicolor/256x256/apps}
    mv usr/lib/deemix/* $out/opt/deemix/

    chmod +x $out/opt/deemix/deemix-gui
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
        $out/opt/deemix/deemix-gui

    wrapProgramShell $out/opt/deemix/deemix-gui \
        "''${gappsWrapperArgs[@]}" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
        --prefix LD_LIBRARY_PATH : ${finalAttrs.libPath}:$out/opt/deemix

    ln -s $out/opt/deemix/deemix-gui $out/bin/deemix

    mv usr/share/pixmaps/deemix.png $out/share/pixmaps/
    ln -s $out/share/pixmaps/deemix.png $out/share/icons/hicolor/256x256/apps/

    ln -s "$desktopItem/share/applications" $out/share/

    runHook postInstall
  '';

  desktopItem = makeDesktopItem {
    name = "deemix";
    exec = "deemix %U";
    icon = "deemix";
    desktopName = "Deemix";
    genericName = "Music Downloader";
    comment = finalAttrs.meta.description;
    categories = [
      "Audio"
      "AudioVideo"
    ];
    startupWMClass = "deemix";
  };

  passthru.tests = {
    deemix = nixosTests.deemix;
  };

  meta = {
    description = "Deezer downloader built from the ashes of Deezloader Remix";
    homepage = "https://github.com/bambanah/deemix";
    downloadPage = "https://github.com/bambanah/deemix/releases";
    changelog = "https://github.com/bambanah/deemix/releases/tag/deemix-gui%40${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ JalilArfaoui ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "deemix";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
