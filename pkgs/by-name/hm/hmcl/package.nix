{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  wrapGAppsHook3,
  copyDesktopItems,
  imagemagick,
  jdk,
  jdk17,
  jdk21,
  hmclJdk ? jdk,
  minecraftJdks ? [
    jdk
    jdk17
    jdk21
  ],
  xorg,
  glib,
  libGL,
  glfw,
  openal,
  libglvnd,
  alsa-lib,
  wayland,
  vulkan-loader,
  libpulseaudio,
  gobject-introspection,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hmcl";
  version = "3.7.6";

  src = fetchurl {
    # HMCL has built-in keys, such as the Microsoft OAuth secret and the CurseForge API key.
    # See https://github.com/HMCL-dev/HMCL/blob/refs/tags/release-3.6.12/.github/workflows/gradle.yml#L26-L28
    url = "https://github.com/HMCL-dev/HMCL/releases/download/v${finalAttrs.version}/HMCL-${finalAttrs.version}.jar";
    hash = "sha256-bgZsQ/5CUeOkbahIV0hQSPHrYfK+EaAIV6uMZzpLOVM=";
  };

  icon = fetchurl {
    url = "https://github.com/HMCL-dev/HMCL/raw/release-${finalAttrs.version}/HMCL/src/main/resources/assets/img/icon@8x.png";
    hash = "sha256-1OVq4ujA2ZHboB7zEk7004kYgl9YcoM4qLq154MZMGo=";
  };

  dontUnpack = true;

  dontWrapGApps = true;

  desktopItems = [
    (makeDesktopItem {
      name = "HMCL";
      exec = "hmcl";
      icon = "hmcl";
      comment = finalAttrs.meta.description;
      desktopName = "HMCL";
      categories = [ "Game" ];
    })
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
    copyDesktopItems
    imagemagick
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/hmcl}
    cp $src $out/lib/hmcl/hmcl.jar

    for n in 16 32 48 64 96 128 256
    do
      size=$n"x"$n
      mkdir -p $out/share/icons/hicolor/$size/apps
      magick ${finalAttrs.icon} -resize $size $out/share/icons/hicolor/$size/apps/hmcl.png
    done

    runHook postInstall
  '';

  fixupPhase =
    let
      libpath = lib.makeLibraryPath (
        [
          libGL
          glfw
          glib
          openal
          libglvnd
          vulkan-loader
        ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [
          xorg.libX11
          xorg.libXxf86vm
          xorg.libXext
          xorg.libXcursor
          xorg.libXrandr
          xorg.libXtst
          libpulseaudio
          wayland
          alsa-lib
        ]
      );
      hmclJdk' = hmclJdk.override {
        enableJavaFX = true; # Necessary for hardware acceleration.
      };
    in
    ''
      runHook preFixup

      makeBinaryWrapper ${hmclJdk'}/bin/java $out/bin/hmcl \
        --add-flags "-jar $out/lib/hmcl/hmcl.jar" \
        --set LD_LIBRARY_PATH ${libpath} \
        --prefix PATH : "${lib.makeBinPath minecraftJdks}"\
        ''${gappsWrapperArgs[@]}

      runHook postFixup
    '';

  passthru.updateScript = lib.getExe (callPackage ./update.nix { });

  meta = {
    homepage = "https://hmcl.huangyuhui.net";
    description = "Minecraft Launcher which is multi-functional, cross-platform and popular";
    changelog = "https://docs.hmcl.net/changelog/stable.html";
    mainProgram = "hmcl";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3Only;
    longDescription = ''
      Hello Minecraft! Launcher (HMCL) is a free, open-source, and cross-platform Minecraft launcher.
      It provides comprehensive support for managing multiple game versions and mod loaders,
      including Forge, NeoForge, Fabric, Quilt, LiteLoader, and OptiFine.

      Note: HMCL manages the Terracotta binary internally. On NixOS, Terracotta-related features
      require `programs.nix-ld` to be enabled, as the runtime-downloaded binary is not patched.
    '';
    maintainers = with lib.maintainers; [
      daru-san
      moraxyc
    ];
    inherit (hmclJdk.meta) platforms;
  };
})
