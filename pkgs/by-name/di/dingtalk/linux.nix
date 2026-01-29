{
  pname,
  version,
  src,
  meta,
  stdenv,
  autoPatchelfHook,
  makeWrapper,
  qt5,
  dpkg,
  copyDesktopItems,
  makeDesktopItem,
  lib,
  alsa-lib,
  apr,
  aprutil,
  at-spi2-atk,
  at-spi2-core,
  cups,
  gtk3,
  libpulseaudio,
  libgbm,
  nspr,
  nss,
  xorg,
  glib,
  gdk-pixbuf,
  freetype,
  fontconfig,
  libdrm,
  libxkbcommon,
  libGLU,
  libglvnd,
  udev,
  libuuid,
  libappindicator-gtk3,
  libdbusmenu-gtk3,
  libXt,
  libXmu,
  pango,
}:

let
  libraries = [
    alsa-lib
    apr
    aprutil
    at-spi2-atk
    at-spi2-core
    cups
    gtk3
    libpulseaudio
    libgbm
    nspr
    nss
    qt5.qtbase
    qt5.qtmultimedia
    qt5.qtsvg
    qt5.qtx11extras
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXtst
    glib
    gdk-pixbuf
    freetype
    fontconfig
    libdrm
    libxkbcommon
    libGLU
    libglvnd
    udev
    libuuid
    libappindicator-gtk3
    libdbusmenu-gtk3
    libXt
    libXmu
    pango
  ];
in
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    meta
    ;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    qt5.wrapQtAppsHook
    copyDesktopItems
    dpkg
  ];

  buildInputs = libraries;
  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/libexec/dingtalk

    # Move version file
    mv opt/apps/com.alibabainc.dingtalk/files/version $out/libexec/dingtalk/version

    # Move main files directly to target directory
    mv opt/apps/com.alibabainc.dingtalk/files/*-Release.*/* $out/libexec/dingtalk/

    # Remove unnecessary files directly from target directory
    # To avoid removing the bundled gtkglext library
    rm -f $out/libexec/dingtalk/{*.a,*.la,*.prl,dingtalk_crash_report,dingtalk_updater,libapr*,libcurl.so.*}
    rm -f $out/libexec/dingtalk/{libdouble-conversion.so.*,libEGL*,libfontconfig*,libfreetype*,libfribidi*,libgdk*}
    rm -f $out/libexec/dingtalk/{libGLES*,libgtk-x11-2.0.so.*,libharfbuzz*,libicu*,libidn2*,libjpeg*,libm.so.*,libnghttp2*}
    rm -f $out/libexec/dingtalk/{libpango-1.0.*,libpangocairo-1.0.*,libpangoft2-1.0.*,libpcre2*,libpng*,libpsl*,libQt5*,libssh2*}
    rm -f $out/libexec/dingtalk/{libstdc++.so.6,libstdc++*,libunistring*,libvk*,libvulkan*,libxcb*,libz*}
    rm -rf $out/libexec/dingtalk/{engines-1_1,imageformats,platform*,swiftshader,xcbglintegrations}
    rm -rf $out/libexec/dingtalk/Resources/{i18n/tool/*.exe,qss/mac}

    # Wrap program with proper environment variables using makeWrapper
    # Unset WAYLAND_DISPLAY because DingTalk has issues with Wayland
    makeWrapper $out/libexec/dingtalk/com.alibabainc.dingtalk $out/bin/dingtalk \
      "''${qtWrapperArgs[@]}" \
      --chdir $out/libexec/dingtalk \
      --unset WAYLAND_DISPLAY \
      --prefix LD_PRELOAD : "$out/libexec/dingtalk/libcef.so" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath libraries}"

    # Install icon following XDG icon specification
    install -Dm644 $out/libexec/dingtalk/Resources/image/common/about/logo.png $out/share/icons/hicolor/512x512/apps/dingtalk.png

    runHook postInstall
  '';

  # Ignore missing dependencies for the bundled gtkglext library and gtk-x11-2.0 libraries
  autoPatchelfIgnoreMissingDeps = [
    "libgdkglext-x11-1.0.so.0"
    "libpangox-1.0.so.0"
    "libgtk-x11-2.0.so.0"
    "libgdk-x11-2.0.so.0"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "dingtalk";
      desktopName = "Dingtalk";
      genericName = "Enterprise Communication Tool";
      categories = [ "Chat" ];
      exec = "dingtalk %u";
      icon = "dingtalk";
      keywords = [ "dingtalk" ];
      mimeTypes = [ "x-scheme-handler/dingtalk" ];
      extraConfig = {
        "Name[zh_CN]" = "钉钉";
        "Name[zh_TW]" = "釘釘";
      };
    })
  ];
  passthru.updateScript = ./update.sh;
}
