{ lib
, stdenv
, appimageTools
, fetchurl
, graphicsmagick
, makeWrapper
, copyDesktopItems
, autoPatchelfHook
, xorg
, libpulseaudio
, libGL
, udev
, xdg-utils
, electron
, addOpenGLRunpath
, makeDesktopItem

, jdk8
, jdk17
, jdks ? [ jdk17 jdk8 ]
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gdlauncher-carbon";
  version = "2.0.2";

  src = appimageTools.extract {
    inherit (finalAttrs) pname version;
    src = fetchurl {
      url = "https://cdn-raw.gdl.gg/launcher/GDLauncher__${finalAttrs.version}__linux__x64.AppImage";
      hash = "sha256-mPvQK+4s0BxR8yi0Fu6HMtWuH7bKj4jvTBFVa+cbZs8=";
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
  ];

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
        --set LD_LIBRARY_PATH ${addOpenGLRunpath.driverLink}/lib:${libPath} \
        --suffix PATH : "${binPath}" \
        --set ELECTRON_FORCE_IS_PACKAGED 1 \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --add-flags $out/share/gdlauncher-carbon/resources/app.asar
    '';

  desktopItems = [
    (makeDesktopItem {
      # Note the desktop file name should be GDLauncher so wayland
      # can find the right desktop file to show a taskbar icon.
      name = "GDLauncher";
      exec = "gdlauncher-carbon";
      icon = "gdlauncher-carbon";
      desktopName = "GDLauncher";
      comment = finalAttrs.meta.description;
      categories = [ "Game" ];
      keywords = [ "launcher" "mod manager" "minecraft" ];
      mimeTypes = [ "x-scheme-handler/gdlauncher" ];
    })
  ];

  meta = {
    description = "A simple, yet powerful Minecraft custom launcher with a strong focus on the user experience";
    homepage = "https://gdlauncher.com/";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [ huantian ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
