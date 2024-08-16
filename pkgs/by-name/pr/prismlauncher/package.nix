{
  lib,
  stdenv,
  symlinkJoin,
  prismlauncher-unwrapped,
  addDriverRunpath,
  alsa-lib,
  flite,
  gamemode,
  glfw,
  glfw-wayland-minecraft,
  glxinfo,
  jdk8,
  jdk17,
  jdk21,
  kdePackages,
  libGL,
  libjack2,
  libpulseaudio,
  libusb1,
  makeWrapper,
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

  # Adds `glfw-wayland-minecraft` to `LD_LIBRARY_PATH`
  # when launched on wayland, allowing for the game to be run natively.
  # Make sure to enable "Use system installation of GLFW" in instance settings
  # for this to take effect
  #
  # Warning: This build of glfw may be unstable, and the launcher
  # itself can take slightly longer to start
  withWaylandGLFW ? false,
}:

assert lib.assertMsg (
  controllerSupport -> stdenv.isLinux
) "controllerSupport only has an effect on Linux.";

assert lib.assertMsg (
  textToSpeechSupport -> stdenv.isLinux
) "textToSpeechSupport only has an effect on Linux.";

assert lib.assertMsg (
  withWaylandGLFW -> stdenv.isLinux
) "withWaylandGLFW is only available on Linux.";

let
  prismlauncher' = prismlauncher-unwrapped.override { inherit msaClientID gamemodeSupport; };
in

symlinkJoin {
  name = "prismlauncher-${prismlauncher'.version}";

  paths = [ prismlauncher' ];

  nativeBuildInputs =
    [ kdePackages.wrapQtAppsHook ]
    # purposefully using a shell wrapper here for variable expansion
    # see https://github.com/NixOS/nixpkgs/issues/172583
    ++ lib.optional withWaylandGLFW makeWrapper;

  buildInputs =
    [
      kdePackages.qtbase
      kdePackages.qtsvg
    ]
    ++ lib.optional (
      lib.versionAtLeast kdePackages.qtbase.version "6" && stdenv.isLinux
    ) kdePackages.qtwayland;

  env = {
    waylandPreExec = lib.optionalString withWaylandGLFW ''
      if [ -n "$WAYLAND_DISPLAY" ]; then
        export LD_LIBRARY_PATH=${lib.getLib glfw-wayland-minecraft}/lib:"$LD_LIBRARY_PATH"
      fi
    '';
  };

  postBuild =
    lib.optionalString withWaylandGLFW ''
      qtWrapperArgs+=(--run "$waylandPreExec")
    ''
    + ''
      wrapQtAppsHook
    '';

  qtWrapperArgs =
    let
      runtimeLibs =
        [
          # lwjgl
          stdenv.cc.cc.lib
          ## native versions
          glfw
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
