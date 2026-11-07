{
  addDriverRunpath,
  alsa-lib,
  flite,
  gamemode,
  glfw3-minecraft,
  jdk17,
  jdk21,
  jdk25,
  jdk8,
  kdePackages,
  lib,
  libGL,
  libdecor,
  libjack2,
  libpulseaudio,
  libusb1,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxkbcommon,
  libxrandr,
  libxxf86vm,
  openal,
  pciutils,
  pineconemc-unwrapped,
  mesa-demos,
  pipewire,
  stdenv,
  symlinkJoin,
  udev,
  vulkan-loader,
  wayland,
  wrapGAppsHook3,
  xrandr,

  additionalLibs ? [ ],
  additionalPrograms ? [ ],
  controllerSupport ? stdenv.hostPlatform.isLinux,
  gamemodeSupport ? stdenv.hostPlatform.isLinux,
  jdks ? [
    jdk25
    jdk21
    jdk17
    jdk8
  ],
  msaClientID ? null,
  textToSpeechSupport ? stdenv.hostPlatform.isLinux,
}:

assert lib.assertMsg (
  controllerSupport -> stdenv.hostPlatform.isLinux
) "controllerSupport only has an effect on Linux.";

assert lib.assertMsg (
  textToSpeechSupport -> stdenv.hostPlatform.isLinux
) "textToSpeechSupport only has an effect on Linux.";

let
  pineconemc' = pineconemc-unwrapped.override { inherit msaClientID; };
in

symlinkJoin {
  pname = "pineconemc";
  inherit (pineconemc') version;

  __structuredAttrs = true;
  strictDeps = true;

  paths = [ pineconemc' ];

  nativeBuildInputs = [
    kdePackages.wrapQtAppsHook
    wrapGAppsHook3
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qtimageformats
    kdePackages.qtsvg
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux kdePackages.qtwayland;

  postBuild = ''
    # Required for org.gtk.Settings.FileChooser
    gappsWrapperArgsHook
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")

    wrapQtAppsHook
  '';

  qtWrapperArgs =
    let
      runtimeLibs = [
        (lib.getLib stdenv.cc.cc)
        ## native versions
        glfw3-minecraft
        openal

        ## openal
        alsa-lib
        libjack2
        libpulseaudio
        pipewire

        ## glfw
        libGL
        libx11
        libxcursor
        libxext
        libxi
        libxrandr
        libxxf86vm
        wayland
        libdecor
        libxkbcommon

        udev # oshi

        vulkan-loader # VulkanMod's lwjgl
      ]
      ++ lib.optional textToSpeechSupport flite
      ++ lib.optional gamemodeSupport gamemode.lib
      ++ lib.optional controllerSupport libusb1
      ++ additionalLibs;

      runtimePrograms = [
        pciutils # need lspci
        xrandr # needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
        mesa-demos
      ]
      ++ additionalPrograms;

    in
    [
      "--set"
      "NIX_LAUNCHER_WRAPPER"
      "${placeholder "out"}/bin/${pineconemc'.meta.mainProgram}"
      "--prefix"
      "PINECONEMC_JAVA_PATHS"
      ":"
      (lib.makeSearchPath "bin/java" jdks)
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "--set"
      "LD_LIBRARY_PATH"
      "${addDriverRunpath.driverLink}/lib:${lib.makeLibraryPath runtimeLibs}"
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath runtimePrograms)
    ];

  meta = {
    inherit (pineconemc'.meta)
      description
      homepage
      license
      maintainers
      mainProgram
      platforms
      ;
  };
}
