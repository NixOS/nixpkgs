{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeBinaryWrapper,
  cacert,
  gitMinimal,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
  addDriverRunpath,

  # gpui
  fontconfig,
  freetype,
  libGL,
  libxcb,
  libxkbcommon,
  vulkan-loader,
  wayland,

  # Minecraft
  alsa-lib,
  flite,
  jdk8,
  jdk17,
  jdk21,
  jdk25,
  libjack2,
  libpulseaudio,
  libx11,
  libxcursor,
  libxext,
  libxrandr,
  libxxf86vm,
  openal,
  pipewire,
  udev,
  xrandr,

  additionalLibs ? [ ],
  additionalPrograms ? [ ],
  jdks ? [
    jdk25
    jdk21
    jdk17
    jdk8
  ],
  textToSpeechSupport ? true,
}:

let
  gameLibs = [
    (lib.getLib stdenv.cc.cc)
    openal

    ## openal
    alsa-lib
    libjack2
    libpulseaudio
    pipewire

    ## lwjgl
    libGL
    libx11
    libxcursor
    libxext
    libxrandr
    libxxf86vm
    wayland

    udev # oshi
    vulkan-loader # VulkanMod's lwjgl
  ]
  ++ lib.optional textToSpeechSupport flite
  ++ additionalLibs;

  gamePrograms = [
    xrandr # needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
  ]
  ++ additionalPrograms;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "riven";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "BX-Team";
    repo = "Riven";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0zCXP99K2FaXv1f8JayEf4ehqWTo5+S6G8Z50JT8pPs=";
  };

  cargoHash = "sha256-TIr8CU43DH5sFbhhWYEFYijtKmWOYIrAW1RqUjJH3Mo=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    fontconfig
    freetype
    libxcb
    libxkbcommon
    wayland
  ];

  nativeCheckInputs = [
    cacert
    gitMinimal
    writableTmpDirAsHomeHook
  ];
  cargoTestFlags = [ "--workspace" ];

  postInstall = ''
    install -Dm644 assets/brand/riven.svg $out/share/icons/hicolor/scalable/apps/riven.svg
    install -Dm644 assets/brand/riven-512.png $out/share/icons/hicolor/512x512/apps/riven.png
    install -Dm644 packaging/linux/riven.desktop $out/share/applications/riven.desktop
    install -Dm644 packaging/linux/riven-mime.xml $out/share/mime/packages/riven.xml
  '';

  # gpui dlopens the graphics and windowing libraries at runtime.
  postFixup = ''
    patchelf $out/bin/riven --add-rpath ${
      lib.makeLibraryPath [
        libGL
        vulkan-loader
        wayland
      ]
    }
    wrapProgram $out/bin/riven \
      --prefix RIVEN_JAVA_PATHS : ${lib.makeSearchPath "bin/java" jdks} \
      --prefix LD_LIBRARY_PATH : ${addDriverRunpath.driverLink}/lib:${lib.makeLibraryPath gameLibs} \
      --prefix PATH : ${lib.makeBinPath gamePrograms}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minecraft launcher and modpack toolkit";
    longDescription = ''
      Riven Launcher is a Minecraft launcher with its own modpack format:
      install and update packs by link, author them from the CLI or the
      launcher's developer section.
    '';
    homepage = "https://github.com/BX-Team/Riven";
    changelog = "https://github.com/BX-Team/Riven/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      nonplay
      wiyba
    ];
    mainProgram = "riven";
    platforms = lib.platforms.linux;
  };
})
