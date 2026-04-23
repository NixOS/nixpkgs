{
  lib,
  stdenv,
  src,
  version,
  basename,
  autoPatchelfHook,
  makeWrapper,
  gnutar,
  unzip,
  makeDesktopItem,
  stlinkServerVersion,
  stlinkUdevVersion,
  jlinkUdevVersion,

  # Core libraries
  glib,
  gtk3,
  gdk-pixbuf,
  pango,
  cairo,
  atk,
  zlib,
  freetype,
  fontconfig,
  libx11,
  libxrender,
  libxtst,
  libxi,
  libxext,
  libxrandr,
  libxcursor,
  libxcomposite,
  libxdamage,
  libxfixes,
  libxinerama,
  libxxf86vm,
  libxcb,
  libxau,
  libxdmcp,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-wm,
  libxkbcommon,
  dbus,
  dbus-glib,

  # Wayland support
  wayland,

  # OpenGL
  libGL,
  libGLU,
  mesa,

  # USB support (for debugging probes)
  libusb1,
  hidapi,

  # Ncurses (mentioned in installer)
  ncurses5,

  # For GDB
  expat,
  python3,

  # SSL/crypto
  openssl,

  # Additional libraries
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  cups,
  udev,
  nspr,
  nss,

  # For CubeProgrammer
  pcsclite,
  xercesc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stm32cubeide";
  inherit version src;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    gnutar
    unzip
  ];

  buildInputs = [
    # Core libraries
    glib
    gtk3
    gdk-pixbuf
    pango
    cairo
    atk
    zlib
    freetype
    fontconfig
    libx11
    libxrender
    libxtst
    libxi
    libxext
    libxrandr
    libxcursor
    libxcomposite
    libxdamage
    libxfixes
    libxinerama
    libxxf86vm
    libxcb
    libxau
    libxdmcp
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm
    libxkbcommon
    dbus
    dbus-glib

    # Wayland support
    wayland

    # OpenGL
    libGL
    libGLU
    mesa

    # USB support (for debugging probes)
    libusb1
    hidapi

    # Ncurses (mentioned in installer)
    ncurses5

    # For GDB
    stdenv.cc.cc.lib
    expat
    python3

    # SSL/crypto
    openssl

    # Additional libraries
    alsa-lib
    at-spi2-atk
    at-spi2-core
    cups
    udev
    nspr
    nss

    # For CubeProgrammer
    pcsclite
    xercesc
  ];

  unpackPhase = ''
    runHook preUnpack

    mkdir source
    cd source
    unzip $src
    bash ${basename}.sh --noexec --target .

    runHook postUnpack
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Extract the main tarball
    mkdir -p $out/opt/stm32cubeide
    tar -xzf ${basename}.tar.gz -C $out/opt/stm32cubeide --strip-components=0

    # Create bin directory
    mkdir -p $out/bin

    # Create wrapper script for the main IDE
    makeWrapper $out/opt/stm32cubeide/stm32cubeide $out/bin/stm32cubeide \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}" \
      --set GTK_THEME "Adwaita"

    # Also create wayland-compatible wrapper (still uses x11 backend)
    makeWrapper $out/opt/stm32cubeide/stm32cubeide $out/bin/stm32cubeide_wayland \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}" \
      --set GDK_BACKEND x11 \
      --set GTK_THEME "Adwaita"

    # Create wrapper for headless build
    if [ -f $out/opt/stm32cubeide/headless-build.sh ]; then
      makeWrapper $out/opt/stm32cubeide/headless-build.sh $out/bin/stm32cubeide-headless \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
    fi

    # Desktop file
    mkdir -p $out/share/applications
    cp -r ${finalAttrs.desktopItem}/share/applications/*.desktop $out/share/applications
    cp -r ${finalAttrs.desktopItemCompat}/share/applications/*.desktop $out/share/applications

    # Copy icon
    mkdir -p $out/share/pixmaps
    mkdir -p $out/share/icons/hicolor/stm32cubeide/apps
    if [ -f $out/opt/stm32cubeide/icon.xpm ]; then
      cp $out/opt/stm32cubeide/icon.xpm $out/share/pixmaps/stm32cubeide.xpm
      cp $out/opt/stm32cubeide/icon.xpm $out/share/icons/hicolor/stm32cubeide/apps/stm32cubeide.xpm
    fi

    # Install stlink-server from the separate package
    mkdir -p $out/opt/stlink-server
    bash st-stlink-server.${stlinkServerVersion}-linux-amd64.install.sh \
      --noexec --target $out/opt/stlink-server

    if [ -f $out/opt/stlink-server/stlink-server ]; then
      chmod +x $out/opt/stlink-server/stlink-server
      makeWrapper $out/opt/stlink-server/stlink-server $out/bin/stlink-server \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libusb1 ]}"
    fi

    # install the various udev rules
    mkdir udev
    bash segger-jlink-udev-rules-${jlinkUdevVersion}-linux-noarch.sh --noexec --target udev
    bash st-stlink-udev-rules-${stlinkUdevVersion}-linux-noarch.sh --noexec --target udev
    mkdir -p $out/lib/udev/rules.d
    cp udev/*.rules $out/lib/udev/rules.d/

    runHook postInstall
  '';

  # autoPatchelfHook settings
  autoPatchelfIgnoreMissingDeps = [
    # These are bundled with the application
    "libjli.so"
    "libSTLinkUSBDriver.so"
    "libhsmp11.so"
    "libPreparation.so.1"
    # Bundled Qt6 (for CubeProgrammer)
    "libQt6Core.so.6"
    "libQt6DBus.so.6"
    "libQt6Gui.so.6"
    "libQt6Network.so.6"
    "libQt6OpenGL.so.6"
    "libQt6Qml.so.6"
    "libQt6SerialPort.so.6"
    "libQt6Widgets.so.6"
    "libQt6XcbQpa.so.6"
    "libQt6Xml.so.6"
    "libQt6EglFSDeviceIntegration.so.6"
    "libQt6WaylandEglClientHwIntegration.so.6"
    "libQt6WaylandClient.so.6"
    # Bundled Qt4 (for JLink tools)
    "libQtCore.so.4"
    "libQtGui.so.4"
    # Bundled JLink
    "libjlinkarm.so"
    "libjlinkarm.so.8"
    # Optional FFmpeg plugins for JRE (not needed for IDE)
    "libavformat-ffmpeg.so.56"
    "libavcodec-ffmpeg.so.56"
    "libavformat.so.54"
    "libavcodec.so.54"
    "libavformat.so.56"
    "libavcodec.so.56"
    "libavformat.so.57"
    "libavcodec.so.57"
    "libavformat.so.58"
    "libavcodec.so.58"
    "libavformat.so.59"
    "libavcodec.so.59"
    "libavformat.so.60"
    "libavcodec.so.60"
    # xerces versioned lib (we have 3.3, it wants 3.2)
    "libxerces-c-3.2.so"
  ];

  # Set rpath for bundled libraries to find each other
  postFixup = ''
    # Fix the CubeProgrammer tools to find their bundled libs
    CUBEPROG_DIR=$(find $out/opt/stm32cubeide/plugins -type d -name "com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.linux64_*" | head -1)
    if [ -n "$CUBEPROG_DIR" ]; then
      patchelf --set-rpath "$CUBEPROG_DIR/tools/lib:${lib.makeLibraryPath finalAttrs.buildInputs}" \
        $CUBEPROG_DIR/tools/bin/STM32_Programmer_CLI || true
    fi

    # Fix JLink tools to find their bundled libs
    JLINK_DIR=$(find $out/opt/stm32cubeide/plugins -type d -name "com.st.stm32cube.ide.mcu.externaltools.jlink.linux64_*" | head -1)
    if [ -n "$JLINK_DIR" ]; then
      for bin in $JLINK_DIR/tools/bin/JLink*; do
        if [ -f "$bin" ] && [ -x "$bin" ]; then
          patchelf --set-rpath "$JLINK_DIR/tools/bin:${lib.makeLibraryPath finalAttrs.buildInputs}" "$bin" || true
        fi
      done
    fi

    # Fix the bundled JRE
    JRE_DIR=$(find $out/opt/stm32cubeide/plugins -type d -name "com.st.stm32cube.ide.jre.linux64_*" | head -1)
    if [ -n "$JRE_DIR" ] && [ -d "$JRE_DIR/jre" ]; then
      for bin in $JRE_DIR/jre/bin/*; do
        if [ -f "$bin" ] && [ -x "$bin" ]; then
          patchelf --set-rpath "$JRE_DIR/jre/lib:$JRE_DIR/jre/lib/server:${lib.makeLibraryPath finalAttrs.buildInputs}" "$bin" || true
        fi
      done
      for lib in $JRE_DIR/jre/lib/*.so $JRE_DIR/jre/lib/server/*.so; do
        if [ -f "$lib" ]; then
          patchelf --set-rpath "$JRE_DIR/jre/lib:$JRE_DIR/jre/lib/server:${lib.makeLibraryPath finalAttrs.buildInputs}" "$lib" || true
        fi
      done
    fi
  '';

  desktopItem = makeDesktopItem {
    name = "stm32cubeide";
    comment = "Integrated Development Environment for STM32";
    genericName = "STM32 IDE";
    desktopName = "STM32CubeIDE ${version}";
    exec = "stm32cubeide %F";
    icon = "stm32cubeide";
    terminal = false;
    startupNotify = true;
    categories = [
      "Development"
      "IDE"
      "Electronics"
    ];
    mimeTypes = [ "application/x-stm32cubeide" ];
  };

  desktopItemCompat = makeDesktopItem {
    name = "stm32cubeide_wayland";
    comment = "Integrated Development Environment for STM32 (Wayland compatibility with X11)";
    genericName = "STM32 IDE";
    desktopName = "STM32CubeIDE ${version} (Wayland Compat)";
    exec = "stm32cubeide_wayland %F";
    icon = "stm32cubeide";
    terminal = false;
    startupNotify = true;
    categories = [
      "Development"
      "IDE"
      "Electronics"
    ];
    mimeTypes = [ "application/x-stm32cubeide" ];
  };

  meta = {
    description = "Integrated Development Environment for STM32 microcontrollers";
    homepage = "https://www.st.com/en/development-tools/stm32cubeide.html";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ sempiternal-aurora ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
