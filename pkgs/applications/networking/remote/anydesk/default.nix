{ lib, stdenv, fetchurl, makeWrapper, makeDesktopItem, genericUpdater, writeShellScript
, atk, cairo, gdk-pixbuf, glib, gnome2, gtk2, libGLU, libGL, pango, xorg, minizip
, lsb-release, freetype, fontconfig, polkit, polkit_gnome, pciutils, copyDesktopItems
, pulseaudio }:

let
  description = "Desktop sharing application, providing remote support and online meetings";
in stdenv.mkDerivation rec {
  pname = "anydesk";
  version = "6.3.0";

  src = fetchurl {
    urls = [
      "https://download.anydesk.com/linux/anydesk-${version}-amd64.tar.gz"
      "https://download.anydesk.com/linux/generic-linux/anydesk-${version}-amd64.tar.gz"
    ];
    hash = "sha256-seMzfTXOGa+TljgpmIsgFOis+79r0bWt+4vH3Nb+5FI=";
  };

  buildInputs = [
    atk cairo gdk-pixbuf glib gtk2 stdenv.cc.cc pango
    gnome2.gtkglext libGLU libGL minizip freetype
    fontconfig polkit polkit_gnome pulseaudio
  ] ++ (with xorg; [
    libxcb libxkbfile libX11 libXdamage libXext libXfixes libXi libXmu
    libXrandr libXtst libXt libICE libSM libXrender
  ]);

  nativeBuildInputs = [ copyDesktopItems makeWrapper ];

  desktopItems = [
    (makeDesktopItem {
      name = "AnyDesk";
      exec = "anydesk %u";
      icon = "anydesk";
      desktopName = "AnyDesk";
      genericName = description;
      categories = [ "Network" ];
      startupNotify = false;
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/{applications,doc/anydesk,icons/hicolor}
    install -m755 anydesk $out/bin/anydesk
    cp copyright README $out/share/doc/anydesk
    cp -r icons/hicolor/* $out/share/icons/hicolor/

    runHook postInstall
  '';

  postFixup = ''
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath "${lib.makeLibraryPath buildInputs}" \
      $out/bin/anydesk

    # pangox is not actually necessary (it was only added as a part of gtkglext)
    patchelf \
      --remove-needed libpangox-1.0.so.0 \
      $out/bin/anydesk

    wrapProgram $out/bin/anydesk \
      --prefix PATH : ${lib.makeBinPath [ lsb-release pciutils ]}
  '';

  passthru = {
    updateScript = genericUpdater {
      versionLister = writeShellScript "anydesk-versionLister" ''
        curl -s https://anydesk.com/en/downloads/linux \
          | grep "https://[a-z0-9._/-]*-amd64.tar.gz" -o \
          | uniq \
          | sed 's,.*/anydesk-\(.*\)-amd64.tar.gz,\1,g'
      '';
    };
  };

  meta = with lib; {
    inherit description;
    homepage = "https://www.anydesk.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ shyim cheriimoya ];
  };
}
