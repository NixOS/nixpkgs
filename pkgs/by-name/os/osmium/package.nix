{
  stdenv,
  fetchurl,
  lib,
  makeDesktopItem,
  makeShellWrapper,
  autoPatchelfHook,
  libgcc,
  libx11,
  libxext,
  libxcb,
  libGL,
  ffmpeg,
  glib,
  dbus,
  pango,
  libxcomposite,
  libxdamage,
  libxrandr,
  libxkbcommon,
  libgbm,
  nss,
  nspr,
  gtk3,
  libnotify,
  libpulseaudio,
  writeShellApplication,
  curl,
  yq,
  common-updater-scripts,
}:

stdenv.mkDerivation rec {
  pname = "osmium";
  version = "0.0.19-alpha";

  src = fetchurl {
    url = "https://updater.osmium.chat/Osmium-${version}-x64.tar.gz";
    hash = "sha256-Qwh6K2QlJJapqR0BkaA0LvwLEsqktnLzOnyJg+7sMFo=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeShellWrapper
  ];

  buildInputs = [
    libgcc
    libx11
    libxext
    libxcb
    ffmpeg
    glib
    dbus
    pango
    libxcomposite
    libxdamage
    libxrandr
    libxkbcommon
    libgbm
    nss
    nspr
    gtk3
    libnotify
    libpulseaudio
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt,share/{pixmaps,icons/hicolor/256x256/apps}}

    mv * $out/opt/
    chmod +x $out/opt/osmium

    ln -s $out/opt/osmium $out/bin/

    wrapProgramShell $out/opt/osmium \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL ]}

    ln -s $out/opt/resources/assets/icons/256x256.png $out/share/pixmaps/osmium.png
    ln -s $out/opt/resources/assets/icons/256x256.png $out/share/icons/hicolor/256x256/apps/osmium.png

    ln -s "$desktopItem/share/applications" $out/share

    runHook postInstall
  '';

  desktopItem = makeDesktopItem {
    name = "osmium";
    exec = "osmium";
    icon = "osmium";
    desktopName = "Osmium";
    genericName = "A globally distributed community messaging and voice/video platform.";
    categories = [
      "Network"
      "InstantMessaging"
    ];
    mimeTypes = [ "x-scheme-handler/osmium" ];
    startupWMClass = "Osmium";
  };

  passthru = {
    updateScript = lib.getExe (writeShellApplication {
      name = "update-osmium";
      runtimeInputs = [
        curl
        yq
        common-updater-scripts
      ];
      text = ''
        version="$(curl -s https://updater.osmium.chat/alpha-linux.yml | yq .version)"
        update-source-version osmium "$version"
      '';
    });
  };

  meta = {
    description = "Globally distributed community messaging and voice/video platform";
    homepage = "https://osmium.chat/";
    license = lib.licenses.unfree;
    mainProgram = "osmium";
    maintainers = with lib.maintainers; [
      twoneis
    ];
    platforms = [
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
