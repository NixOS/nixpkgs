{
  lib,
  stdenv,
  fetchurl,

  makeBinaryWrapper,
  makeDesktopItem,
  copyDesktopItems,

  jre,

  # deps
  alsa-lib,
  libjack2,
  libpulseaudio,
  pipewire,
  libGL,
  libX11,
  libXcursor,
  libXext,
  libXrandr,
  libXxf86vm,

  # runtime (path)
  xrandr,

  # native
  unzip,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ocelot-desktop";
  version = "1.14.1";

  __darwinAllowLocalNetworking = true;

  # Cannot build from source because sbt/scala support is completely non-existent in nixpkgs
  src = fetchurl {
    url = "https://gitlab.com/api/v4/projects/9941848/packages/generic/ocelot-desktop/v${finalAttrs.version}/ocelot-desktop-v${finalAttrs.version}.jar";
    hash = "sha256-OO+fgb9PO72znb2sU0olxFf+YuWZvgZkWdszFPpMZg8=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  preferLocal = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    copyDesktopItems
    unzip
  ];

  installPhase =
    let
      # does darwin need any deps?
      runtimeLibs = lib.optionals stdenv.hostPlatform.isLinux [
        # openal
        alsa-lib
        libjack2
        libpulseaudio
        pipewire

        # lwjgl
        libGL
        libX11
        libXcursor
        libXext
        libXrandr
        libXxf86vm
      ];
      runtimePrograms = lib.optionals stdenv.hostPlatform.isLinux [
        # https://github.com/LWJGL/lwjgl/issues/128
        xrandr
      ];
    in
    ''
      runHook preInstall

      mkdir -p $out/{bin,share/ocelot-desktop}
      install -Dm644 ${finalAttrs.src} $out/share/ocelot-desktop/ocelot-desktop.jar

      makeBinaryWrapper ${jre}/bin/java $out/bin/ocelot-desktop \
        --set JAVA_HOME ${jre.home} \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
        --prefix PATH : "${lib.makeBinPath runtimePrograms}" \
        --add-flags "-jar $out/share/ocelot-desktop/ocelot-desktop.jar"

      # copy icons from zip file
      # ocelot/desktop/images/icon*.png
      # 16,32,64,128,256

      for size in 16 32 64 128 256; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        unzip -p $out/share/ocelot-desktop/ocelot-desktop.jar \
          ocelot/desktop/images/icon"$size".png > $out/share/icons/hicolor/"$size"x"$size"/apps/ocelot-desktop.png
      done

      runHook postInstall
    '';

  desktopItems = [
    (makeDesktopItem {
      name = "ocelot-desktop";
      desktopName = "Ocelot Desktop";
      genericName = "OpenComputers Emulator";
      comment = "An advanced OpenComputers emulator";
      tryExec = "ocelot-desktop";
      exec = "ocelot-desktop -w %f";
      icon = "ocelot-desktop";
      startupNotify = true;
      startupWMClass = "Ocelot Desktop"; # (maybe broken)
      terminal = false;
      keywords = [
        "Ocelot"
        "OpenComputers"
        "Emulator"
        "oc"
        "lua"
        "OpenOS"
        "ocemu"
        "mc"
        "Minecraft"
      ];
      categories = [
        "Development"
        "Emulator"
      ];
      mimeTypes = [
        "inode/directory"
      ];
    })
  ];

  meta = {
    description = "Advanced OpenComputers emulator";
    homepage = "https://ocelot.fomalhaut.me/desktop";
    changelog = "https://gitlab.com/cc-ru/ocelot/ocelot-desktop/-/releases/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "ocelot-desktop";
    platforms = with lib.platforms; linux ++ darwin;
    badPlatforms = [
      # missing compatible lwjgl.dylib
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ griffi-gh ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
