{
  addDriverRunpath,
  alsa-lib,
  flite,
  gamemode,
  glfw3-minecraft,
  jdk17,
  jdk21,
  jdk8,
  qt6Packages,
  lib,
  libGL,
  libX11,
  libXcursor,
  libXext,
  libXrandr,
  libXxf86vm,
  libjack2,
  libpulseaudio,
  libusb1,
  mesa-demos,
  openal,
  pciutils,
  pipewire,
  projtlauncher-unwrapped,
  stdenv,
  symlinkJoin,
  udev,
  vulkan-loader,
  xrandr,

  additionalLibs ? [ ],
  additionalPrograms ? [ ],
  controllerSupport ? stdenv.hostPlatform.isLinux,
  gamemodeSupport ? stdenv.hostPlatform.isLinux,
  jdks ? [
    jdk21 # need for newest Minecraft versions
    jdk17 # need for old and new Minecraft versions
    jdk8 # need for legacy Minecraft versions
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
  projtlauncher' = projtlauncher-unwrapped.override { inherit msaClientID gamemodeSupport; };
in

symlinkJoin {
  pname = "projtlauncher";
  inherit (projtlauncher') version;

  paths = [ projtlauncher' ];

  nativeBuildInputs = [ qt6Packages.wrapQtAppsHook ];

  buildInputs = [
    qt6Packages.qtbase
    qt6Packages.qtsvg
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux qt6Packages.qtwayland;

  postBuild = ''
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
        libX11
        libXcursor
        libXext
        libXrandr
        libXxf86vm

        udev # oshi

        vulkan-loader # VulkanMod's lwjgl
      ]
      ++ lib.optional textToSpeechSupport flite
      ++ lib.optional gamemodeSupport gamemode.lib
      ++ lib.optional controllerSupport libusb1
      ++ additionalLibs;

      runtimePrograms = [
        mesa-demos
        pciutils # need lspci
        xrandr # needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
      ]
      ++ additionalPrograms;

    in
    [ "--prefix PROJTLAUNCHER_JAVA_PATHS : ${lib.makeSearchPath "bin/java" jdks}" ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "--set LD_LIBRARY_PATH ${addDriverRunpath.driverLink}/lib:${lib.makeLibraryPath runtimeLibs}"
      "--prefix PATH : ${lib.makeBinPath runtimePrograms}"
    ];

  meta = {
    inherit (projtlauncher'.meta)
      description
      longDescription
      homepage
      changelog
      license
      maintainers
      mainProgram
      platforms
      ;
  };
}
