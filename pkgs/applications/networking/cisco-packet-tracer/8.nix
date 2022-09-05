{ stdenv
, lib
, alsa-lib
, autoPatchelfHook
, buildFHSUserEnvBubblewrap
, callPackage
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
, requireFile
, xorg
}:

let
  version = "8.1.1";

  ptFiles = stdenv.mkDerivation {
    name = "PacketTracer8Drv";
    inherit version;

    dontUnpack = true;
    src = requireFile {
      name = "CiscoPacketTracer_${builtins.replaceStrings ["."] [""] version}_Ubuntu_64bit.deb";
      sha256 = "08c53171aa0257a64ae7de1540f242214033cfa4f879fbc9fed5cc0d32232abf";
      url = "https://www.netacad.com";
    };

    nativeBuildInputs = [
      alsa-lib
      autoPatchelfHook
      dbus
      dpkg
      expat
      fontconfig
      glib
      libdrm
      libglvnd
      libpulseaudio
      libudev0-shim
      libxkbcommon
      libxml2
      libxslt
      makeWrapper
      nspr
      nss
    ] ++ (with xorg; [
      libICE
      libSM
      libX11
      libxcb
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libXrandr
      libXrender
      libXScrnSaver
      libXtst
      xcbutilimage
      xcbutilkeysyms
      xcbutilrenderutil
      xcbutilwm
    ]);

    installPhase = ''
      dpkg-deb -x $src $out
      chmod 755 "$out"
      makeWrapper "$out/opt/pt/bin/PacketTracer" "$out/bin/packettracer" \
        --prefix LD_LIBRARY_PATH : "$out/opt/pt/bin"

      # Keep source archive cached, to avoid re-downloading
      ln -s $src $out/usr/share/
    '';
  };

  desktopItem = makeDesktopItem {
    name = "cisco-pt8.desktop";
    desktopName = "Cisco Packet Tracer 8";
    icon = "${ptFiles}/opt/pt/art/app.png";
    exec = "packettracer8 %f";
    mimeTypes = [ "application/x-pkt" "application/x-pka" "application/x-pkz" ];
  };

  fhs = buildFHSUserEnvBubblewrap {
    name = "packettracer8";
    runScript = "${ptFiles}/bin/packettracer";
    targetPkgs = pkgs: [ libudev0-shim ];

    extraInstallCommands = ''
      mkdir -p "$out/share/applications"
      cp "${desktopItem}"/share/applications/* "$out/share/applications/"
    '';
  };
in stdenv.mkDerivation {
  pname = "ciscoPacketTracer8";
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
    maintainers = with maintainers; [ lucasew ];
    platforms = [ "x86_64-linux" ];
  };
}
