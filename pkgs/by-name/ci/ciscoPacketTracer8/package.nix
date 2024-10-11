{ stdenvNoCC
, lib
, alsa-lib
, autoPatchelfHook
, copyDesktopItems
, dbus
, dpkg
, expat
, fontconfig
, glib
, makeDesktopItem
, makeWrapper
, qt5
, requireFile
}:

let
  hashes = {
    "8.2.0" = "sha256-GxmIXVn2Ew7lVBT7AuIRoXc0YGids4v9Gsfw1FEX7RY=";
    "8.2.1" = "sha256-QoM4rDKkdNTJ6TBDPCAs+l17JLnspQFlly9B60hOB7o=";
    "8.2.2" = "sha256-bNK4iR35LSyti2/cR0gPwIneCFxPP+leuA1UUKKn9y0=";
  };
  names = {
    "8.2.0" = "CiscoPacketTracer_820_Ubuntu_64bit.deb";
    "8.2.1" = "CiscoPacketTracer_821_Ubuntu_64bit.deb";
    "8.2.2" = "CiscoPacketTracer822_amd64_signed.deb";
  };
in

stdenvNoCC.mkDerivation (args: {
  pname = "ciscoPacketTracer8";

  version = "8.2.2";

  src = requireFile {
    name = names.${args.version};
    hash = hashes.${args.version};
    url = "https://www.netacad.com";
  };

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x $src $out
    chmod 755 "$out"

    runHook postUnpack
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    dpkg
    makeWrapper
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    dbus
    expat
    fontconfig
    glib
    qt5.qtbase
    qt5.qtmultimedia
    qt5.qtnetworkauth
    qt5.qtscript
    qt5.qtspeech
    qt5.qtwebengine
    qt5.qtwebsockets
  ];

  installPhase = ''
    runHook preInstall

    makeWrapper "$out/opt/pt/bin/PacketTracer" "$out/bin/packettracer8" \
      "''${qtWrapperArgs[@]}" \
      --set QT_QPA_PLATFORMTHEME "" \
      --prefix LD_LIBRARY_PATH : "$out/opt/pt/bin"

    install -D $out/opt/pt/art/app.png $out/share/icons/hicolor/128x128/apps/ciscoPacketTracer8.png

    rm $out/opt/pt/bin/libQt5* -f

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "cisco-pt8.desktop";
      desktopName = "Cisco Packet Tracer 8";
      icon = "ciscoPacketTracer8";
      exec = "packettracer8 %f";
      mimeTypes = [ "application/x-pkt" "application/x-pka" "application/x-pkz" ];
    })
  ];

  dontWrapQtApps = true;

  passthru = {
    inherit hashes;
  };

  meta = with lib; {
    description = "Network simulation tool from Cisco";
    homepage = "https://www.netacad.com/courses/packet-tracer";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "packettracer8";
  };
})
