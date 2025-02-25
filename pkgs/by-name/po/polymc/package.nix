{
  addDriverRunpath,
  flite,
  gamemode,
  glfw,
  jdk17,
  jdk21,
  jdk8,
  kdePackages,
  lib,
  libGL,
  libX11,
  libXcursor,
  libXext,
  libXrandr,
  libXxf86vm,
  libpulseaudio,
  libusb1,
  mangohud,
  mesa-demos,
  openal,
  polymc-unwrapped,
  stdenv,
  symlinkJoin,
  udev,
  vulkan-loader,
  wayland,
  xrandr,

  jdks ? [
    jdk21
    jdk17
    jdk8
  ],
  gamemodeSupport ? stdenv.hostPlatform.isLinux,
  mangohudSupport ? stdenv.hostPlatform.isLinux,
  additionalLibs ? [ ],
  additionalPrograms ? [ ],
  msaClientID ? null,
}:

assert lib.assertMsg (
  gamemodeSupport -> stdenv.hostPlatform.isLinux
) "gamemodeSupport is only available on Linux.";

assert lib.assertMsg (
  mangohudSupport -> stdenv.hostPlatform.isLinux
) "mangohudSupport is only available on Linux.";

let
  polymc' = polymc-unwrapped.override {
    inherit gamemodeSupport msaClientID;
  };
  mangohud-lib = symlinkJoin {
    name = "mangohud-lib";
    paths = [ mangohud ];
    postBuild = ''
      mv $out/lib/mangohud/* $out/lib
      rmdir $out/lib/mangohud
    '';
  };
in

symlinkJoin {
  name = "polymc-${polymc'.version}";

  paths = [ polymc' ];

  nativeBuildInputs = [ kdePackages.wrapQtAppsHook ];

  buildInputs =
    [ kdePackages.qtbase ]
    ++ lib.optional (
      lib.versionAtLeast kdePackages.qtbase.version "6" && stdenv.hostPlatform.isLinux
    ) kdePackages.qtwayland;

  postBuild = "wrapQtAppsHook";

  qtWrapperArgs =
    let
      runtimeLibs =
        [
          stdenv.cc.cc.lib
          glfw
          openal
          libpulseaudio
          wayland

          # glfw
          libGL
          libX11
          libXcursor
          libXext
          libXrandr
          libXxf86vm

          udev # oshi

          vulkan-loader # VulkanMod's lwjgl
        ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [
          flite
          libusb1
        ]
        ++ lib.optional gamemodeSupport gamemode.lib
        ++ lib.optional mangohudSupport mangohud-lib
        ++ additionalLibs;

      runtimePrograms = [
        xrandr
        mesa-demos
      ] ++ additionalPrograms;
    in
    [
      "--set LD_LIBRARY_PATH ${addDriverRunpath.driverLink}/lib:${lib.makeLibraryPath runtimeLibs}"
      "--prefix POLYMC_JAVA_PATHS : ${lib.makeSearchPath "bin/java" jdks}"
      "--prefix PATH : ${lib.makeBinPath runtimePrograms}"
    ];

  inherit (polymc') meta;
}
