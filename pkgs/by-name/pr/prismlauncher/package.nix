{
  lib,
  stdenv,
  symlinkJoin,
  prismlauncher-unwrapped,
  addDriverRunpath,
  flite,
  gamemode,
  glfw3-minecraft,
  glxinfo,
  jdk8,
  jdk17,
  jdk21,
  kdePackages,
  libGL,
  libpulseaudio,
  libusb1,
  openal,
  pciutils,
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
          # lwjgl
          glfw3-minecraft
          libpulseaudio
          libGL
          openal
          stdenv.cc.cc.lib

          vulkan-loader # VulkanMod's lwjgl

          udev # oshi

          xorg.libX11
          xorg.libXext
          xorg.libXcursor
          xorg.libXrandr
          xorg.libXxf86vm
        ]
        ++ lib.optional textToSpeechSupport flite
        ++ lib.optional gamemodeSupport gamemode.lib
        ++ lib.optional controllerSupport libusb1
        ++ additionalLibs;

      runtimePrograms = [
        glxinfo
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
