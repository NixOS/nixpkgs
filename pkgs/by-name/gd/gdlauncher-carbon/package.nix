{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  graphicsmagick,
  makeWrapper,
  copyDesktopItems,
  autoPatchelfHook,
  xorg,
  libpulseaudio,
  libGL,
  udev,
  xdg-utils,
  electron,
  addDriverRunpath,
  makeDesktopItem,

  jdk8,
  jdk17,
  jdk21,
  jdks ? [
    jdk8
    jdk17
    jdk21
  ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gdlauncher-carbon";
  version = "2.0.24";

  src = appimageTools.extract {
    inherit (finalAttrs) pname version;
    src = fetchurl {
      url = "https://cdn-raw.gdl.gg/launcher/GDLauncher__${finalAttrs.version}__linux__x64.AppImage";
      hash = "sha256-d5ZvWSLA/7mY0540TDLMW9qmEFA5xC6Zd83IWakOmGo=";
    };
  };

  nativeBuildInputs = [
    graphicsmagick
    makeWrapper
    copyDesktopItems
    autoPatchelfHook
  ];

  buildInputs = [
    xorg.libxcb
    stdenv.cc.cc.lib
  ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/gdlauncher-carbon/resources
    cp -r $src/resources/{binaries,app.asar} $out/share/gdlauncher-carbon/resources/

    # The provided icon is a bit large for some systems, so make smaller ones
    for size in 48 96 128 256 512; do
      gm convert $src/@gddesktop.png -resize ''${size}x''${size} icon_$size.png
      install -D icon_$size.png $out/share/icons/hicolor/''${size}x''${size}/apps/gdlauncher-carbon.png
    done

    runHook postInstall
  '';

  postConfigure =
    let
      libPath = lib.makeLibraryPath [
        xorg.libX11
        xorg.libXext
        xorg.libXcursor
        xorg.libXrandr
        xorg.libXxf86vm

        # lwjgl
        libpulseaudio
        libGL
        stdenv.cc.cc.lib

        # oshi
        udev
      ];
      binPath = lib.makeBinPath [
        # Used for opening directories and URLs in the electron app
        xdg-utils

        # xorg.xrandr needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
        xorg.xrandr
      ];
    in
    ''
      makeWrapper '${lib.getExe electron}' $out/bin/gdlauncher-carbon \
        --prefix GDL_JAVA_PATH : ${lib.makeSearchPath "" jdks} \
        --set LD_LIBRARY_PATH ${addDriverRunpath.driverLink}/lib:${libPath} \
        --suffix PATH : "${binPath}" \
        --set ELECTRON_FORCE_IS_PACKAGED 1 \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --add-flags $out/share/gdlauncher-carbon/resources/app.asar
    '';

  desktopItems = [
    (makeDesktopItem {
      # Note the desktop file name should be GDLauncher to match the window's
      # client id for window icon purposes on wayland.
      name = "GDLauncher";
      exec = "gdlauncher-carbon";
      icon = "gdlauncher-carbon";
      desktopName = "GDLauncher";
      comment = finalAttrs.meta.description;
      categories = [ "Game" ];
      keywords = [
        "launcher"
        "mod manager"
        "minecraft"
      ];
      mimeTypes = [ "x-scheme-handler/gdlauncher" ];
    })
  ];

  meta = {
    description = "Simple, yet powerful Minecraft custom launcher with a strong focus on the user experience";
    homepage = "https://gdlauncher.com/";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [
      huantian
      TsubakiDev
    ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
