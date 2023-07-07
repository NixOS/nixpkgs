{ stdenvNoCC
, lib
, alsa-lib
, autoPatchelfHook
, buildFHSEnv
, ciscoPacketTracer8
, copyDesktopItems
, dbus
, dpkg
, expat
, fontconfig
, glib
, libdrm
, libglvnd
, libpulseaudio
, libudev0-shim
, libxkbcommon
, libxml2
, libxslt
, lndir
, makeDesktopItem
, makeWrapper
, nspr
, nss
, qt5
, requireFile
, xorg
}:

let
  hashes = {
    "8.2.0" = "1b19885d59f6130ee55414fb02e211a1773460689db38bfd1ac7f0d45117ed16";
    "8.2.1" = "1fh79r4fnh9gjxjh39gcp4j7npgs5hh3qhrhx74x8x546an3i0s2";
  };
in

stdenvNoCC.mkDerivation rec {
  pname = "ciscoPacketTracer8";

  version = "8.2.1";

  src = requireFile {
    name = "CiscoPacketTracer_${builtins.replaceStrings ["."] [""] version}_Ubuntu_64bit.deb";
    sha256 = hashes.${version};
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
    maintainers = with maintainers; [ lucasew ];
    platforms = [ "x86_64-linux" ];
  };
}
