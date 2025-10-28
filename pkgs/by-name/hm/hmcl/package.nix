{
  lib,
  stdenv,

  fetchurl,
  fetchFromGitHub,

  gradle,
  unzip,
  replaceVars,
  makeDesktopItem,
  wrapGAppsHook3,
  copyDesktopItems,
  stripJavaArchivesHook,
  desktopToDarwinBundle,
  imagemagick,
  callPackage,

  jdk,
  jdk17,
  jdk21,
  xorg,
  glib,
  libGL,
  libusb1,
  udev,
  flite,
  glfw3-minecraft,
  openal,
  libglvnd,
  alsa-lib,
  wayland,
  vulkan-loader,
  libpulseaudio,
  terracotta,
  gobject-introspection,
  zenity,

  hmclJdk ? jdk,
  minecraftJdks ? [
    jdk
    jdk17
    jdk21
  ],

  extraLibs ? [ ],
  extraPrograms ? [ ],
  controllerSupport ? stdenv.hostPlatform.isLinux,
  textToSpeechSupport ? stdenv.hostPlatform.isLinux,
}:

# Copied from prismlauncher
assert lib.assertMsg (
  controllerSupport -> stdenv.hostPlatform.isLinux
) "controllerSupport only has an effect on Linux.";

assert lib.assertMsg (
  textToSpeechSupport -> stdenv.hostPlatform.isLinux
) "textToSpeechSupport only has an effect on Linux.";

let
  hmclJdk' = hmclJdk.override { enableJavaFX = true; };
  # Reduce closure size
  minecraftJdks' = lib.lists.remove hmclJdk minecraftJdks ++ [ hmclJdk' ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hmcl";
  version = "3.7.3";

  src = fetchFromGitHub {
    owner = "HMCL-dev";
    repo = "HMCL";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3YeVMaMKgyndnxnKjPaP0M0xdMpqc2L809t1v4mhmKM=";
  };

  patches = [
    # For deterministic
    ./0001-nix-do-not-output-timestamp.patch
    # Do not download binary file
    (replaceVars ./0002-nix-use-terracotta-from-nix.patch { TERRACOTTA_BIN = lib.getExe terracotta; })
  ];

  postPatch = ''
    substituteInPlace HMCL/build.gradle.kts \
      --replace-fail 'dependsOn(createPropertiesFile)' "" \
      --replace-fail '$versionRoot.SNAPSHOT' '${finalAttrs.version}'
    # Credentials
    unzip -j ${finalAttrs.passthru.jar} assets/hmcl.properties -d HMCL/build/
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
    copyDesktopItems
    gobject-introspection
    gradle
    imagemagick
    stripJavaArchivesHook
    unzip
    wrapGAppsHook3
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  # Use native JavaFX for platforms compatibility
  gradleFlags = [ "-Dorg.gradle.java.home=${hmclJdk'.home}" ];

  gradleUpdateScript = ''
    runHook preBuild

    gradle help --write-verification-metadata sha256
  '';

  gradleBuildTask = "shadowJar";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/hmcl}
    cp HMCL/build/libs/HMCL-${finalAttrs.version}.jar $out/lib/hmcl/hmcl.jar

    for n in 16 32 48 64 96 128 256
    do
      size=$n"x"$n
      mkdir -p $out/share/icons/hicolor/$size/apps
      magick HMCL/src/main/resources/assets/img/icon@8x.png -resize $size $out/share/icons/hicolor/$size/apps/hmcl.png
    done

    runHook postInstall
  '';

  fixupPhase =
    let
      runtimeLibs = [
        # When use native libs
        openal
        glfw3-minecraft

        libGL
        glib
        libglvnd
        vulkan-loader
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        # glfw
        xorg.libX11
        xorg.libXxf86vm
        xorg.libXext
        xorg.libXcursor
        xorg.libXrandr
        xorg.libXtst

        # oshi
        udev

        ## openal
        alsa-lib
        libpulseaudio

        wayland
      ]
      ++ lib.optional textToSpeechSupport flite
      ++ lib.optional controllerSupport libusb1
      ++ extraLibs;
      runtimePrograms = [
        # Required by tiny file dialogs
        zenity
      ]
      ++ minecraftJdks'
      ++ extraPrograms;
    in
    ''
      runHook preFixup

      makeBinaryWrapper ${hmclJdk'}/bin/java $out/bin/hmcl \
        --add-flags "-jar $out/lib/hmcl/hmcl.jar" \
        --set LD_LIBRARY_PATH ${lib.makeLibraryPath runtimeLibs} \
        --prefix PATH : "${lib.makeBinPath runtimePrograms}"\
        ''${gappsWrapperArgs[@]}

      runHook postFixup
    '';

  passthru = {
    updateScript = lib.getExe (callPackage ./update.nix { });
    jar = fetchurl {
      url = "https://github.com/HMCL-dev/HMCL/releases/download/v${finalAttrs.version}/HMCL-${finalAttrs.version}.jar";
      hash = "sha256-VE/83KD1xIrkD6BGBK0rJpbKuNPOpmNSC/RHjhRsGco=";
    };
  };

  meta = {
    homepage = "https://hmcl.huangyuhui.net";
    description = "Minecraft Launcher which is multi-functional, cross-platform and popular";
    changelog = "https://docs.hmcl.net/changelog/stable.html";
    mainProgram = "hmcl";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      daru-san
      moraxyc
    ];
    inherit (hmclJdk'.meta) platforms;
  };
})
