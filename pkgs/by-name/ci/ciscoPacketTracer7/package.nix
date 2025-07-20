{
  stdenvNoCC,
  lib,
  buildFHSEnv,
  copyDesktopItems,
  dpkg,
  libxml2_13,
  alsa-lib,
  dbus,
  expat,
  fontconfig,
  glib,
  libglvnd,
  libpulseaudio,
  libudev0-shim,
  libxkbcommon,
  libxslt,
  nspr,
  nss,
  xorg,
  makeDesktopItem,
  makeWrapper,
  requireFile,
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
          name = "PacketTracer_${lib.replaceString "." "" version}_amd64.deb";
          hash = "sha256-w5gC0V3WHQC6J/uMEW2kX9hWKrS0mZZVWtZriN6s4n8=";
          url = "https://www.netacad.com";
        };

    nativeBuildInputs = [
      dpkg
      makeWrapper
    ];

    unpackPhase = ''
      runHook preUnpack

      dpkg-deb -x $src $out
      chmod 755 "$out"

      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      makeWrapper "$out/opt/pt/bin/PacketTracer7" "$out/bin/packettracer7" \
        --prefix LD_LIBRARY_PATH : "$out/opt/pt/bin"

      runHook postInstall
    '';
  };

  fhs-env = buildFHSEnv {
    name = "ciscoPacketTracer7-fhs-env";
    runScript = lib.getExe' unwrapped "packettracer7";
    targetPkgs = _: [
      alsa-lib
      dbus
      expat
      fontconfig
      glib
      libglvnd
      libpulseaudio
      libudev0-shim
      libxkbcommon
      libxml2_13
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
stdenvNoCC.mkDerivation {
  pname = "ciscoPacketTracer7";
  inherit version;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s ${fhs-env}/bin/${fhs-env.name} $out/bin/packettracer7

    # TODO: icons

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "cisco-pt7.desktop";
      desktopName = "Cisco Packet Tracer 7";
      # TODO
      icon = "${unwrapped}/opt/pt/art/app.png";
      exec = "packettracer7 %f";
      mimeTypes = [
        "application/x-pkt"
        "application/x-pka"
        "application/x-pkz"
      ];
    })
  ];

  nativeBuildInputs = [ copyDesktopItems ];

  meta = {
    description = "Network simulation tool from Cisco";
    homepage = "https://www.netacad.com/courses/packet-tracer";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      gepbird
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
