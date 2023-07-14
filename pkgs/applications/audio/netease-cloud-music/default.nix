{ lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, makeWrapper
  # , qt5
, xorg
, libdrm
, alsa-lib
, taglib
, vlc
, krb5
, gtk2
, gtk3
, tcp_wrappers
, e2fsprogs
, gnutls
, avahi
, sqlite
, libogg
, libvorbis
, libsndfile
, libasyncns
, dbus-glib
, cups
, nspr
, gnome2
, nss
, icu60
, libinput
, mtdev
, libpulseaudio
  # , libjpeg_original
  # , double-conversion
  # , eudev
}:
stdenv.mkDerivation rec {
  pname = "netease-cloud-music";
  version = "1.2.1";
  src = fetchurl {
    url = "https://d1.music.126.net/dmusic/netease-cloud-music_1.2.1_amd64_ubuntu_20190428.deb";
    sha256 = "sha256-HunwKELmwsjHnEiy6TIHT5whOo60I45eY/IEOFYv7Ls=";
    curlOpts = "-AMozilla/5.0";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];
  # some libraries' versions don't match, comment them
  buildInputs = [
    stdenv.cc.cc.lib
    # qt5.qtbase
    # qt5.qtdeclarative
    # qt5.qtwebchannel
    # qt5.qtx11extras
    # xorg.libXtst
    xorg.libXScrnSaver
    xorg.xcbutilkeysyms
    xorg.xcbutilimage
    xorg.xcbutilwm
    xorg.xcbutilrenderutil
    libdrm
    alsa-lib
    taglib
    vlc
    krb5
    gtk2
    gtk3
    tcp_wrappers
    e2fsprogs
    gnutls
    avahi
    sqlite
    libogg
    libvorbis
    libsndfile
    libasyncns
    dbus-glib
    cups
    nspr
    gnome2.GConf
    nss
    icu60
    libinput
    mtdev
    libpulseaudio
    # libjpeg_original
    # double-conversion
    # eudev
  ];

  # Refer https://aur.archlinux.org/cgit/aur.git/tree/exclude.list?h=netease-cloud-music
  # don't use NixOS's qt5
  # --set QT_PLUGIN_PATH "${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}" \
  # --set QT_QPA_PLATFORM_PLUGIN_PATH "${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}/platforms" \
  installPhase = ''
    install -D opt/netease/netease-cloud-music/netease-cloud-music -t $out/bin
    install -Dm644 \
      opt/netease/netease-cloud-music/libs/libdouble-conversion.so.1 \
      opt/netease/netease-cloud-music/libs/libjpeg.so.8 \
      opt/netease/netease-cloud-music/libs/libqcef.so.1.1.4 \
      opt/netease/netease-cloud-music/libs/libudev.so.1 \
      opt/netease/netease-cloud-music/libs/libXtst.so.6 \
      opt/netease/netease-cloud-music/libs/libQt5Core.so.5 \
      opt/netease/netease-cloud-music/libs/libQt5Gui.so.5 \
      opt/netease/netease-cloud-music/libs/libQt5XcbQpa.so.5 \
      opt/netease/netease-cloud-music/libs/libQt5Network.so.5 \
      opt/netease/netease-cloud-music/libs/libQt5Xml.so.5 \
      opt/netease/netease-cloud-music/libs/libQt5Qml.so.5 \
      opt/netease/netease-cloud-music/libs/libQt5Svg.so.5 \
      opt/netease/netease-cloud-music/libs/libQt5EglFSDeviceIntegration.so.5 \
      opt/netease/netease-cloud-music/libs/libQt5X11Extras.so.5 \
      opt/netease/netease-cloud-music/libs/libQt5DBus.so.5 \
      opt/netease/netease-cloud-music/libs/libQt5WebChannel.so.5 \
      opt/netease/netease-cloud-music/libs/libQt5Widgets.so.5 \
      -t $out/lib/netease-cloud-music
    cp -r opt/netease/netease-cloud-music/plugins $out/lib/netease-cloud-music
    cp -r opt/netease/netease-cloud-music/libs/qcef $out/lib/netease-cloud-music
    cp -r usr/share $out
  '';

  preFixup = ''
    rm -r *
    ln -s libqcef.so.1.1.4 $out/lib/netease-cloud-music/libqcef.so.1
  '';
  postFixup = ''
    wrapProgram $out/bin/netease-cloud-music \
      --set QT_PLUGIN_PATH "$out/lib/netease-cloud-music/plugins" \
      --set QT_QPA_PLATFORM_PLUGIN_PATH "$out/lib/netease-cloud-music/plugins/platforms" \
      --set QCEF_INSTALL_PATH "$out/lib/netease-cloud-music/qcef" \
      --set QT_XKB_CONFIG_ROOT "${xorg.xkeyboardconfig}/share/X11/xkb" \
      --set XDG_SESSION_TYPE x11 \
      --set QT_QPA_PLATFORM xcb
  '';

  meta = with lib; {
    description = "Client for Netease Cloud Music service";
    homepage = "https://music.163.com";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mlatus Freed-Wu ];
    license = licenses.unfree;
  };
}
