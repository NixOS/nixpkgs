{
  fetchurl,
  stdenv,
  autoPatchelfHook,
  makeWrapper,
  lib,
  alsa-lib,
  apr,
  aprutil,
  at-spi2-atk,
  at-spi2-core,
  cups,
  gtk3,
  libpulseaudio,
  gnome2,
  mesa,
  nspr,
  nss,
  qt5,
  xorg,
  dpkg,
  libsForQt5,
  imagemagick,
  gtk2-x11,
  gdk-pixbuf,
  cairo,
  curl,
  dbus,
  e2fsprogs,
  fontconfig,
  freetype,
  fribidi,
  glib,
  gnutls,
  graphite2,
  harfbuzz,
  icu63,
  krb5,
  libdrm,
  libgcrypt,
  libGLU,
  libglvnd,
  libidn2,
  libinput,
  libjpeg,
  libpng,
  libpsl,
  libssh2,
  libthai,
  libxcrypt-legacy,
  libxkbcommon,
  mtdev,
  openldap,
  copyDesktopItems,
  makeDesktopItem,
  openssl_1_1,
  nghttp2,
  pcre2,
  pango,
  rtmpdump,
  udev,
  util-linux,
  gst_all_1,
}:
let
  libraries = [
    alsa-lib
    apr
    aprutil
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    curl
    dbus
    e2fsprogs
    fontconfig
    freetype
    fribidi
    gdk-pixbuf
    glib
    gnome2.gtkglext
    gnutls
    graphite2
    gtk3
    harfbuzz
    icu63
    krb5
    libdrm
    libgcrypt
    libGLU
    libglvnd
    libidn2
    libinput
    libjpeg
    libpng
    libpsl
    libpulseaudio
    libssh2
    libthai
    libxcrypt-legacy
    libxkbcommon
    mesa
    mtdev
    nghttp2
    nspr
    nss
    openldap
    openssl_1_1
    pango
    pcre2
    qt5.qtbase
    qt5.qtmultimedia
    qt5.qtsvg
    qt5.qtx11extras
    rtmpdump
    udev
    util-linux
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXmu
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXt
    xorg.libXtst
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dingtalk";
  version = "7.6.45.5062501";
  src =
    let

      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system}
          or (throw "dingtalk: ${stdenv.hostPlatform.system} is not supported");
      arch = selectSystem {
        x86_64-linux = "amd64";
        aarch64-linux = "arm64";
      };
    in
    fetchurl {
      url = "https://dtapp-pub.dingtalk.com/dingtalk-desktop/xc_dingtalk_update/linux_deb/Release/com.alibabainc.dingtalk_${finalAttrs.version}_${arch}.deb";
      hash = selectSystem {
        x86_64-linux = "sha256-49pmBducAxUy7ZqQg+tdDquFeR+lJczpcF8m+VvhIo8=";
        aarch64-linux = "sha256-ebIKFfJ8s3w0yGXapTWYtPSz8QgLsN6ujj2k9mQFR2k=";
      };
    };

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
      runHook preUnpack
    dpkg -x $src .
    mv opt/apps/com.alibabainc.dingtalk/files/version version
    mv opt/apps/com.alibabainc.dingtalk/files/*-Release.* release
    rm -f release/{*.a,*.la,*.prl,dingtalk_crash_report,dingtalk_updater,libapr*,libcrypto.so.*,libcurl.so.*}
    rm -f release/{libdouble-conversion.so.*,libEGL*,libfontconfig*,libfreetype*,libfribidi*,libgdk*,libGLES*}
    rm -f release/{libgtk*,libgtk-x11-2.0.so.*,libharfbuzz*,libicu*,libidn2*,libjpeg*,libm.so.*,libnghttp2*}
    rm -f release/{libpango-1.0.*,libpangocairo-1.0.*,libpangoft2-1.0.*,libpcre2*,libpng*,libpsl*,libQt5*,libssh2*}
    rm -f release/{libssl.*,libstdc++.so.6,libstdc++*,libunistring*,libvk*,libvulkan*,libxcb*,libz*}
    rm -rf release/{engines-1_1,imageformats,platform*,swiftshader,xcbglintegrations}
    rm -rf release/Resources/{i18n/tool/*.exe,qss/mac}
    runHook postUnpack
    runHook preInstall

    install -Dm644 version $out/version
    mv release $out/lib
    mkdir -p $out/bin
    ln -s $out/lib/com.alibabainc.dingtalk $out/bin/dingtalk
    chmod +x $out/bin/dingtalk

    wrapProgram $out/bin/dingtalk \
      "''${qtWrapperArgs[@]}" \
      --chdir $out/lib \
      --unset WAYLAND_DISPLAY \
      --prefix LD_PRELOAD : "$out/lib/libcef.so" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath libraries}"

    install -Dm644 $out/lib/Resources/image/common/about/logo.png $out/share/pixmaps/dingtalk.png
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "dingtalk";
      desktopName = "Dingtalk";
      genericName = "dingtalk";
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

  meta = {
    description = "Enterprise-level communication platform developed by Alibaba";
    homepage = "https://www.dingtalk.com";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ nyxvectar ];
    mainProgram = "dingtalk";
  };
})
