{
  lib,
  stdenvNoCC,
  requireFile,
  autoPatchelfHook,
  dpkg,
  makeWrapper,
  alsa-lib,
  dbus,
  expat,
  fontconfig,
  glib,
  libdrm,
  libglvnd,
  libpulseaudio,
  libudev0-shim,
  libxkbcommon,
  libxml2_13,
  libxslt,
  nspr,
  nss,
  xorg,
  buildFHSEnv,
  copyDesktopItems,
  makeDesktopItem,
  packetTracerSource ? null,
}:

let
  version = "7.3.1";

  unwrapped = stdenvNoCC.mkDerivation {
    pname = "ciscoPacketTracer7-unwrapped";
    inherit version;

    src =
      if (packetTracerSource != null) then
        packetTracerSource
      else
        requireFile {
          name = "PacketTracer_731_amd64.deb";
          hash = "sha256-w5gC0V3WHQC6J/uMEW2kX9hWKrS0mZZVWtZriN6s4n8=";
          url = "https://www.netacad.com";
        };

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      makeWrapper
    ];

    buildInputs = [
      alsa-lib
      dbus
      expat
      fontconfig
      glib
      libdrm
      libglvnd
      libpulseaudio
      libudev0-shim
      libxkbcommon
      libxml2_13
      libxslt
      nspr
      nss
    ]
    ++ (with xorg; [
      libICE
      libSM
      libX11
      libXScrnSaver
    ]);

    unpackPhase = ''
      runHook preUnpack

      dpkg-deb -x $src $out
      chmod 755 "$out"

      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      makeWrapper "$out/opt/pt/bin/PacketTracer7" "$out/bin/packettracer7" \
        --set QT_QPA_PLATFORM xcb \
        --prefix LD_LIBRARY_PATH : "$out/opt/pt/bin"

      runHook postInstall
    '';
  };

  fhs-env = buildFHSEnv {
    name = "ciscoPacketTracer7-fhs-env";
    runScript = lib.getExe' unwrapped "packettracer7";
    targetPkgs = _: [ libudev0-shim ];
  };
in
stdenvNoCC.mkDerivation {
  pname = "ciscoPacketTracer7";
  inherit version;

  dontUnpack = true;

  nativeBuildInputs = [
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s ${fhs-env}/bin/${fhs-env.name} $out/bin/packettracer7

    mkdir -p $out/share/icons/hicolor/48x48/apps
    ln -s ${unwrapped}/opt/pt/art/app.png $out/share/icons/hicolor/48x48/apps/cisco-packet-tracer-7.png
    ln -s ${unwrapped}/usr/share/icons/gnome/48x48/mimetypes $out/share/icons/hicolor/48x48/mimetypes
    ln -s ${unwrapped}/usr/share/mime $out/share/mime

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "cisco-pt7.desktop";
      desktopName = "Cisco Packet Tracer 7";
      icon = "cisco-packet-tracer-7";
      exec = "packettracer7 %f";
      mimeTypes = [
        "application/x-pkt"
        "application/x-pka"
        "application/x-pkz"
      ];
    })
  ];

  meta = {
    description = "Network simulation tool from Cisco";
    homepage = "https://www.netacad.com/courses/packet-tracer";
    license = lib.licenses.unfree;
    mainProgram = "packettracer7";
    maintainers = with lib.maintainers; [
      gepbird
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
