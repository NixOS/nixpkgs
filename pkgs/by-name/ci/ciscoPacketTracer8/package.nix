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
  wayland,
  xorg,
  buildFHSEnv,
  copyDesktopItems,
  makeDesktopItem,
  version ? "8.2.2",
  packetTracerSource ? null,
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

  unwrapped = stdenvNoCC.mkDerivation {
    name = "ciscoPacketTracer8-unwrapped";
    inherit version;

    src =
      if (packetTracerSource != null) then
        packetTracerSource
      else
        requireFile {
          name = names.${version};
          hash = hashes.${version};
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
      wayland
    ]
    ++ (with xorg; [
      libICE
      libSM
      libX11
      libXScrnSaver
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libXrandr
      libXrender
      libXtst
      libxcb
      xcbutilimage
      xcbutilkeysyms
      xcbutilrenderutil
      xcbutilwm
    ]);

    unpackPhase = ''
      runHook preUnpack

      dpkg-deb -x $src $out
      chmod 755 "$out"

      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      makeWrapper "$out/opt/pt/bin/PacketTracer" "$out/bin/packettracer8" \
        --set QT_QPA_PLATFORM xcb \
        --prefix LD_LIBRARY_PATH : "$out/opt/pt/bin"

      runHook postInstall
    '';
  };

  fhs-env = buildFHSEnv {
    name = "ciscoPacketTracer8-fhs-env";
    runScript = lib.getExe' unwrapped "packettracer8";
    targetPkgs = _: [ libudev0-shim ];
  };
in

stdenvNoCC.mkDerivation {
  pname = "ciscoPacketTracer8";
  inherit version;

  dontUnpack = true;

  nativeBuildInputs = [
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s ${fhs-env}/bin/${fhs-env.name} $out/bin/packettracer8

    mkdir -p $out/share/icons/hicolor/48x48/apps
    ln -s ${unwrapped}/opt/pt/art/app.png $out/share/icons/hicolor/48x48/apps/cisco-packet-tracer-8.png
    ln -s ${unwrapped}/usr/share/icons/gnome/48x48/mimetypes $out/share/icons/hicolor/48x48/mimetypes
    ln -s ${unwrapped}/usr/share/mime $out/share/mime

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "cisco-pt8.desktop";
      desktopName = "Cisco Packet Tracer 8";
      icon = "cisco-packet-tracer-8";
      exec = "packettracer8 %f";
      mimeTypes = [
        "application/x-pkt"
        "application/x-pka"
        "application/x-pkz"
        "application/x-pksz"
        "application/x-pks"
      ];
    })
  ];

  meta = {
    description = "Network simulation tool from Cisco";
    homepage = "https://www.netacad.com/courses/packet-tracer";
    license = lib.licenses.unfree;
    mainProgram = "packettracer8";
    maintainers = with lib.maintainers; [
      gepbird
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
