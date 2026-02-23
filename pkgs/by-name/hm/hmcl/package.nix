{
  lib,
  stdenv,
  fetchurl,
  replaceVars,
  terracotta,
  makeDesktopItem,
  makeWrapper,
  wrapGAppsHook3,
  copyDesktopItems,
  desktopToDarwinBundle,
  jdk,
  jdk17,
  hmclJdk ? jdk.override {
    # Required by jar file
    enableJavaFX = true;
  },
  buildPackages,
  hmclJdkBuild ? buildPackages.jdk.override {
    enableJavaFX = true;
  },
  minecraftJdks ? [
    hmclJdk
    jdk17
  ],
  libxxf86vm,
  libxtst,
  libxrandr,
  libxext,
  libxcursor,
  libx11,
  xrandr,
  glib,
  libGL,
  glfw3-minecraft,
  openal,
  libglvnd,
  alsa-lib,
  wayland,
  vulkan-loader,
  libpulseaudio,
  gobject-introspection,
  callPackage,
  gtk3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hmcl";
  version = "3.10.3";

  src = fetchurl {
    # HMCL has built-in keys, such as the Microsoft OAuth secret and the CurseForge API key.
    # See https://github.com/HMCL-dev/HMCL/blob/refs/tags/release-3.6.12/.github/workflows/gradle.yml#L26-L28
    url = "https://github.com/HMCL-dev/HMCL/releases/download/v${finalAttrs.version}/HMCL-${finalAttrs.version}.jar";
    hash = "sha256-+xxDACa2ECbWaCUzK0b/rcRS49Hex4GZDcNNK/aEURs=";
  };

  # - HMCL prompts users to download prebuilt Terracotta binary for
  #   multi-user functionality, which is messy and doesn’t work on NixOS.
  # - Building from source isn’t feasible because HMCL’s code relies on
  #   Microsoft OAuth, CurseForge, and other API keys that upstream doesn’t
  #   allow in custom builds, causing features to break.
  # - Our workaround is to compile only the Java files that handle
  #   Terracotta downloads, package them into a patch jar that overrides
  #   the original classes, and have it load the original jar. This preserves
  #   the original jar’s integrity check and avoids modifying the upstream jar.
  terracottaBundleJava = fetchurl {
    name = "hmcl-terracotta-bundle-java-${finalAttrs.version}";
    url = "https://raw.githubusercontent.com/HMCL-dev/HMCL/v${finalAttrs.version}/${finalAttrs.terracottaBundleJavaPath}";
    hash = "sha256-QXjo/NiYQyJfan15hnvJlBir9s9R6H+jHsr+K9M1oTw=";
  };
  macOSProviderJava = fetchurl {
    name = "hmcl-macos-provider-java-${finalAttrs.version}";
    url = "https://raw.githubusercontent.com/HMCL-dev/HMCL/v${finalAttrs.version}/${finalAttrs.macOSProviderJavaPath}";
    hash = "sha256-+Zji2B8ksT7P+IObyrM9q7vHPJVl5ZtH+v/J8Mfr0Q4=";
  };
  terracottaBundleJavaPath = "HMCL/src/main/java/org/jackhuang/hmcl/terracotta/TerracottaBundle.java";
  macOSProviderJavaPath = "HMCL/src/main/java/org/jackhuang/hmcl/terracotta/provider/MacOSProvider.java";

  dontUnpack = true;

  prePatch = ''
    install -Dm644 $terracottaBundleJava $terracottaBundleJavaPath
    install -Dm644 $macOSProviderJava $macOSProviderJavaPath
  '';

  patches = [
    (replaceVars ./0001-nix-use-terracotta-from-nix.patch {
      TERRACOTTA_BIN = lib.getExe terracotta;
    })
    ./0002-nix-skip-terracotta-existence-check-on-darwin.patch
  ];

  buildPhase = ''
    runHook preBuild

    # Build only classes we modified
    javac -cp $src -d out $terracottaBundleJavaPath $macOSProviderJavaPath

    # Extract MANIFEST.MF from original jar
    # We need Main-Class, Add-Opens, etc
    jar xf $src META-INF/MANIFEST.MF
    # Remove last empty line; otherwise file is invalid
    sed -i '/^[[:space:]]*$/d' META-INF/MANIFEST.MF
    # Let our patch jar be the entrace and load hmcl.jar
    echo "Class-Path: $out/lib/hmcl/hmcl.jar" >> META-INF/MANIFEST.MF

    # Package our patch jar
    # Reserve link to terracotta by not applying zip; nix cannot detect path from zipped jar
    jar cvf0m patch.jar META-INF/MANIFEST.MF -C out .

    runHook postBuild
  '';

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
    makeWrapper
    wrapGAppsHook3
    copyDesktopItems
    hmclJdkBuild
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  runtimeDeps = [
    libGL
    glfw3-minecraft
    glib
    openal
    libglvnd
    vulkan-loader
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    libxxf86vm
    libxext
    libxcursor
    libxrandr
    libxtst
    libpulseaudio
    wayland
    alsa-lib
    gtk3
  ];

  installPhase = ''
    runHook preInstall

    install -Dm444 $src $out/lib/hmcl/hmcl.jar
    install -Dm444 patch.jar $out/lib/hmcl/hmcl-terracotta-patch.jar

    jar xf $src assets/img
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm444 assets/img/icon-title.png $out/share/icons/hicolor/24x24/apps/hmcl.png
    install -Dm444 assets/img/icon.png $out/share/icons/hicolor/32x32/apps/hmcl.png
    install -Dm444 assets/img/icon-title@2x.png $out/share/icons/hicolor/48x48/apps/hmcl.png
    install -Dm444 assets/img/icon@2x.png $out/share/icons/hicolor/64x64/apps/hmcl.png
    install -Dm444 assets/img/icon@4x.png $out/share/icons/hicolor/128x128/apps/hmcl.png
    install -Dm444 assets/img/icon@8x.png $out/share/icons/hicolor/256x256/apps/hmcl.png
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    install -Dm444 assets/img/icon-mac.png $out/share/icons/hicolor/512x512/apps/hmcl.png
  ''
  + ''
    runHook postInstall
  '';

  postFixup = ''
    makeShellWrapper ${hmclJdk}/bin/java $out/bin/hmcl \
      --add-flags "-jar $out/lib/hmcl/hmcl-terracotta-patch.jar" \
      --add-flags "-Djdk.gtk.version=3" \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath finalAttrs.runtimeDeps} \
      --prefix PATH : "${
        lib.makeBinPath (minecraftJdks ++ lib.optional stdenv.hostPlatform.isLinux xrandr)
      }" \
      --run 'cd $HOME' \
      --prefix JAVA_TOOL_OPTIONS " " "-Dorg.lwjgl.glfw.libname=${lib.getLib glfw3-minecraft}/lib/libglfw.so" \
      ''${gappsWrapperArgs[@]}
  '';

  passthru.updateScript = lib.getExe (callPackage ./update.nix { });

  meta = {
    homepage = "https://hmcl.huangyuhui.net";
    description = "Minecraft Launcher which is multi-functional, cross-platform and popular";
    changelog = "https://docs.hmcl.net/changelog/stable.html";
    mainProgram = "hmcl";
    sourceProvenance = with lib.sourceTypes; [
      fromSource # Our patch jar is built from source
      binaryBytecode
    ];
    license = lib.licenses.gpl3Only;
    longDescription = ''
      Hello Minecraft! Launcher (HMCL) is a free, open-source, and cross-platform Minecraft launcher.
      It provides comprehensive support for managing multiple game versions and mod loaders,
      including Forge, NeoForge, Fabric, Quilt, LiteLoader, and OptiFine.
    '';
    maintainers = with lib.maintainers; [
      daru-san
      Misaka13514
      moraxyc
    ];
    inherit (hmclJdk.meta) platforms;
  };
})
