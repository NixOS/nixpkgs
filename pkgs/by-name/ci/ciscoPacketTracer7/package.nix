{
  stdenv,
  lib,
  buildFHSEnv,
  copyDesktopItems,
  dpkg,
  lndir,
  makeDesktopItem,
  makeWrapper,
  requireFile,
}:

let
  version = "7.3.1";

  ptFiles = stdenv.mkDerivation {
    pname = "PacketTracer7drv";
    inherit version;

    dontUnpack = true;
    src = requireFile {
      name = "PacketTracer_${builtins.replaceStrings [ "." ] [ "" ] version}_amd64.deb";
      hash = "sha256-w5gC0V3WHQC6J/uMEW2kX9hWKrS0mZZVWtZriN6s4n8=";
      url = "https://www.netacad.com";
    };

    nativeBuildInputs = [
      dpkg
      makeWrapper
    ];

    installPhase = ''
      dpkg-deb -x $src $out
      makeWrapper "$out/opt/pt/bin/PacketTracer7" "$out/bin/packettracer7" \
          --prefix LD_LIBRARY_PATH : "$out/opt/pt/bin"
    '';
  };

  desktopItem = makeDesktopItem {
    name = "cisco-pt7.desktop";
    desktopName = "Cisco Packet Tracer 7";
    icon = "${ptFiles}/opt/pt/art/app.png";
    exec = "packettracer7 %f";
    mimeTypes = [
      "application/x-pkt"
      "application/x-pka"
      "application/x-pkz"
    ];
  };

  fhs = buildFHSEnv {
    pname = "packettracer7";
    inherit version;
    runScript = "${ptFiles}/bin/packettracer7";

    targetPkgs =
      pkgs: with pkgs; [
        alsa-lib
        dbus
        expat
        fontconfig
        glib
        libglvnd
        libpulseaudio
        libudev0-shim
        libxkbcommon
        libxml2
        libxslt
        nspr
        nss
        xorg.libICE
        xorg.libSM
        xorg.libX11
        xorg.libXScrnSaver
      ];
  };
in
stdenv.mkDerivation {
  pname = "ciscoPacketTracer7";
  inherit version;

  dontUnpack = true;

  installPhase = ''
    mkdir $out
    ${lndir}/bin/lndir -silent ${fhs} $out
  '';

  desktopItems = [ desktopItem ];

  nativeBuildInputs = [ copyDesktopItems ];

  meta = with lib; {
    description = "Network simulation tool from Cisco";
    homepage = "https://www.netacad.com/courses/packet-tracer";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
