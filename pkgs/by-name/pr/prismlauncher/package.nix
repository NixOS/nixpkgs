{
  lib,
  stdenv,
  symlinkJoin,
  prismlauncher-unwrapped,
  addDriverRunpath,
  alsa-lib,
  flite,
  gamemode,
  glfw3-minecraft,
  jdk8,
  jdk17,
  jdk21,
  kdePackages,
  libGL,
  libjack2,
  libpulseaudio,
  libusb1,
  mesa-demos,
  openal,
  pciutils,
  pipewire,
  udev,
  vulkan-loader,
  xorg,

  additionalLibs ? [ ],
  additionalPrograms ? [ ],
  controllerSupport ? stdenv.isLinux,
  gamemodeSupport ? stdenv.isLinux,
  jdks ? [
    jdk21
    jdk17
    jdk8
  ],
  msaClientID ? null,
  textToSpeechSupport ? stdenv.isLinux,
}:

assert lib.assertMsg (
  controllerSupport -> stdenv.isLinux
) "controllerSupport only has an effect on Linux.";

assert lib.assertMsg (
  textToSpeechSupport -> stdenv.isLinux
) "textToSpeechSupport only has an effect on Linux.";

let
  prismlauncher' = prismlauncher-unwrapped.override { inherit msaClientID gamemodeSupport; };
in

symlinkJoin {
  name = "prismlauncher-${prismlauncher'.version}";

  paths = [ prismlauncher' ];

  nativeBuildInputs = [ kdePackages.wrapQtAppsHook ];

  buildInputs =
    [
      kdePackages.qtbase
      kdePackages.qtsvg
    ]
    ++ lib.optional (
      lib.versionAtLeast kdePackages.qtbase.version "6" && stdenv.isLinux
    ) kdePackages.qtwayland;

  postBuild = ''
    wrapQtAppsHook
  '';

  qtWrapperArgs =
    let
      runtimeLibs =
        [
          stdenv.cc.cc.lib
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
          xorg.libX11
          xorg.libXext
          xorg.libXcursor
          xorg.libXrandr
          xorg.libXxf86vm

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
        xorg.xrandr # needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
      ] ++ additionalPrograms;

    in
    [ "--prefix PRISMLAUNCHER_JAVA_PATHS : ${lib.makeSearchPath "bin/java" jdks}" ]
    ++ lib.optionals stdenv.isLinux [
      "--set LD_LIBRARY_PATH ${addDriverRunpath.driverLink}/lib:${lib.makeLibraryPath runtimeLibs}"
      "--prefix PATH : ${lib.makeBinPath runtimePrograms}"
    ];

  meta = {
    inherit (prismlauncher'.meta)
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
