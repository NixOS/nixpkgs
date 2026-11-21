{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  copyDesktopItems,
  makeDesktopItem,
  alsa-lib,
  curl,
  gst_all_1,
  gtk3,
  linux-pam,
  libpulseaudio,
  libva,
  libvdpau,
  libxcb,
  libxfixes,
  libxrandr,
  systemd,
  xdotool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hoptodesk";
  version = "1.45.9";

  src = fetchurl {
    url = "https://www.hoptodesk.com/download/hoptodesk-${finalAttrs.version}-x86_64.deb";
    hash = "sha256-1v+TODpUsYQqMVSzGModmpNcisMWjLwrx93Kz/D/QXA=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    dpkg
  ];

  buildInputs = [
    alsa-lib
    curl
    gst_all_1.gst-plugins-base
    gtk3
    linux-pam
    libpulseaudio
    libva
    libvdpau
    libxcb
    libxfixes
    (lib.getLib stdenv.cc.cc)
    systemd
    xdotool
    libxrandr
  ];

  dontConfigure = true;
  dontBuild = true;

  preFixup = ''
    # The .deb bundles libsciter-gtk.so alongside the binary
    addAutoPatchelfSearchPath $out/lib
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/share

    # Install binary
    install -Dm755 usr/bin/hoptodesk $out/bin/hoptodesk

    # Install bundled library
    install -Dm644 usr/lib/libsciter-gtk.so $out/lib/libsciter-gtk.so

    # Install icons
    install -Dm644 usr/share/icons/hicolor/128x128/128x128.png \
      $out/share/icons/hicolor/128x128/apps/hoptodesk.png
    install -Dm644 usr/share/icons/hicolor/32x32/32x32.png \
      $out/share/icons/hicolor/32x32/apps/hoptodesk.png

    # Install systemd service
    install -Dm644 usr/share/hoptodesk/files/systemd/hoptodesk.service \
      $out/lib/systemd/system/hoptodesk.service
    substituteInPlace $out/lib/systemd/system/hoptodesk.service \
      --replace-quiet "/usr/bin/hoptodesk" "$out/bin/hoptodesk"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "hoptodesk";
      desktopName = "HopToDesk";
      genericName = "Remote Desktop Software";
      comment = "Remote Desktop Software";
      exec = "hoptodesk %u";
      icon = "hoptodesk";
      terminal = false;
      type = "Application";
      startupNotify = true;
      categories = [
        "Network"
        "RemoteAccess"
        "GTK"
      ];
      keywords = [ "internet" ];
    })
  ];

  meta = {
    description = "Remote desktop application with peer-to-peer connection";
    homepage = "https://www.hoptodesk.com";
    license = lib.licenses.agpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      hoptodesk
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "hoptodesk";
  };
})
