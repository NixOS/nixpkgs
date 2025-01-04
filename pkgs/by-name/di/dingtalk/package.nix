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
  nghttp2,
  openldap,
  pango,
  pcre2,
  rtmpdump,
  udev,
  util-linux,
  gst_all_1,
}:
stdenv.mkDerivation rec {
  pname = "dingtalk";
  version = "7.6.25.4122001";

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
      url = "https://dtapp-pub.dingtalk.com/dingtalk-desktop/xc_dingtalk_update/linux_deb/Release/com.alibabainc.dingtalk_${version}_${arch}.deb";
      hash = selectSystem {
        x86_64-linux = "sha256-Fjzlqj/ALgYAipEVxdk7FUk83KsgDstcHYVojbK+aD4=";
        aarch64-linux = "sha256-ekRU2HSshqsD+b7XDBiHV/JqQeqConiOZy7k34+nlC8=";
      };
    };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    qt5.wrapQtAppsHook
    dpkg
    imagemagick
  ];

  buildInputs =
    [
      xorg.libXdamage
      xorg.libXrandr
      alsa-lib
      libpulseaudio
      nss
      nspr
      at-spi2-atk
      cups
      at-spi2-core
      gtk3
      gtk2-x11
    ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-libav
    ];

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/app $out/share/pixmaps
    cp -r opt/apps/com.alibabainc.dingtalk/files/*-Release.* $out/app/dingtalk
    rm -f $out/app/dingtalk/{*.a,*.la,*.prl,dingtalk_crash_report,dingtalk_updater,libapr*,libcurl.so.*}
    rm -f $out/app/dingtalk/{libdouble-conversion.so.*,libEGL*,libfontconfig*,libfreetype*,libfribidi*,libgbm.*,libgdk*,libGLES*}
    rm -f $out/app/dingtalk/{libgtk*,libgtk-x11-2.0.so.*,libharfbuzz*,libicu*,libidn2*,libjpeg*,libm.so.*,libnghttp2*}
    rm -f $out/app/dingtalk/{libpango-1.0.*,libpangocairo-1.0.*,libpangoft2-1.0.*,libpcre2*,libpng*,libpsl*,libQt5*,libssh2*}
    rm -f $out/app/dingtalk/{libstdc++.so.6,libstdc++*,libunistring*,libvk*,libvulkan*,libxcb*,libz*}
    rm -rf $out/app/dingtalk/{engines-1_1,imageformats,platform*,swiftshader,xcbglintegrations}
    rm -rf $out/app/dingtalk/Resources/{i18n/tool/*.exe,qss/mac,web_content/NativeWebContent_*.zip}
    install -Dm644 usr/share/applications/com.alibabainc.dingtalk.desktop $out/share/applications/dingtalk.desktop
    magick "opt/apps/com.alibabainc.dingtalk/files/logo.ico" $out/share/pixmaps/dingtalk.png
    substituteInPlace $out/share/applications/dingtalk.desktop \
      --replace-fail "/opt/apps/com.alibabainc.dingtalk/files/Elevator.sh" "dingtalk" \
      --replace-fail "/opt/apps/com.alibabainc.dingtalk/files/logo.ico" "dingtalk"
    cp -r opt/apps/com.alibabainc.dingtalk/files/doc $out/share/doc

    runHook postInstall
  '';

  preFixup = ''
    makeWrapper $out/app/dingtalk/com.alibabainc.dingtalk $out/bin/dingtalk \
      ''${qtWrapperArgs[@]} \
      --argv0 com.alibabainc.dingtalk \
      --chdir $out/app/dingtalk \
      --set QT_QPA_PLATFORM "wayland;xcb" \
      --set QT_AUTO_SCREEN_SCALE_FACTOR 1 \
      --prefix LD_PRELOAD : $out/app/dingtalk/plugins/dtwebview/libcef.so \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          (lib.getLib stdenv.cc.cc)
          mesa
          apr
          aprutil
          libsForQt5.qtmultimedia
          libsForQt5.qtbase
          libsForQt5.qtx11extras
          libsForQt5.qtsvg
          gdk-pixbuf
          alsa-lib
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
          glib
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
          gnome2.gtkglext
          libthai
          libxcrypt-legacy
          libxkbcommon
          mtdev
          nghttp2
          nspr
          nss
          openldap
          pango
          pcre2
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
        ]
      }
  '';

  meta = {
    description = "Enterprise communication and collaboration platform developed by Alibaba Group";
    homepage = "https://www.dingtalk.com";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ aucub ];
  };
}
