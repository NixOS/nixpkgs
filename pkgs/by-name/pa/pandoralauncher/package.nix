{
  lib,
  stdenv,
  makeWrapper,
  symlinkJoin,
  pandoralauncher-unwrapped,
  wayland,
  vulkan-loader,
  glfw3-minecraft,
  openal,
  libGL,
  libX11,
  libXcursor,
  libXext,
  libXrandr,
  libXxf86vm,
  flite,
  alsa-lib,
  libjack2,
  libpulseaudio,
  pipewire,
  udev,
  xrandr,
  jdk8,
  jdk17,
  jdk21,
  jdk25,

  jdks ? [
    jdk8
    jdk17
    jdk21
    jdk25
  ],
}:

symlinkJoin {
  pname = "pandoralauncher";
  inherit (pandoralauncher-unwrapped) version;

  paths = [ pandoralauncher-unwrapped ];

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  postBuild =
    let
      runtimeLibs = [
        wayland
        vulkan-loader

        # native
        glfw3-minecraft
        openal

        # glfw
        libGL
        libX11
        libXcursor
        libXext
        libXrandr
        libXxf86vm

        # lwjgl
        (lib.getLib stdenv.cc.cc)

        # narrator support
        flite

        # openal
        alsa-lib
        libjack2
        libpulseaudio
        pipewire

        # oshi
        udev
      ];

      runtimePrograms = [
        xrandr # needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
      ];
    in
    ''
      wrapProgram $out/bin/pandora_launcher \
      --prefix FORCE_EXTERNAL_JAVA : ${lib.makeSearchPath "bin/java" jdks} \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath runtimeLibs} \
      --prefix PATH : ${lib.makeBinPath runtimePrograms}
    '';

  meta = {
    inherit (pandoralauncher-unwrapped.meta)
      description
      homepage
      license
      mainProgram
      maintainers
      platforms
      ;
  };
}
