{
  stdenv,
  lib,
  symlinkJoin,
  addDriverRunpath,

  msaClientID ? null,
  msaRequired ? true,
  enableLTO ? false,
  gamemodeSupport ? stdenv.isLinux,

  jdks ? [
    jdk25
    jdk21
    jdk17
    jdk8
  ],
  jdk25,
  jdk21,
  jdk17,
  jdk8,

  additionalLibraries ? [ ],
  additionalBinaries ? [ ],

  polymc-unwrapped,
  kdePackages,
  mesa-demos,
  gamemode,
  mangohud,

  xorg,
  libpulseaudio,
  libGL,
  glfw,
  openal,
  udev,
  wayland,
  vulkan-loader,
}:

/*
    Feel free to override msaRequired to `false' on your machine, as
    it's intended to NOT require an account to use the launcher.

    It's set to true by default so (mostly) nobody complains about "muh piracy",
    as if you couldn't just avoid any form of DRM by executing the .jar file directly.

    You're paying to play on Mojang authenticated servers, singleplayer is free.
*/

let
  polymc = polymc-unwrapped.override {
    inherit
      msaClientID
      msaRequired
      gamemodeSupport
      enableLTO
      ;
  };
in
symlinkJoin {
  name = "polymc";
  inherit (polymc) version meta;

  paths = [ polymc ];
  nativeBuildInputs = [ kdePackages.wrapQtAppsHook ];
  buildInputs = with kdePackages; [
    qtbase
    qtwayland
  ];

  postBuild = ''wrapQtAppsHook'';

  qtWrapperArgs =
    let
      runtimeLibs =
        (with xorg; [
          libX11
          libXext
          libXcursor
          libXrandr
          libXxf86vm
        ])
        ++ [
          libpulseaudio
          libGL
          glfw
          openal
          stdenv.cc.cc.lib
          udev # OSHI
          wayland
          vulkan-loader # VulkanMod's lwjgl
        ]
        ++ lib.optional gamemodeSupport gamemode.lib
        ++ additionalLibraries;

      runtimeBins = [
        # Required by old LWJGL versions
        xorg.xrandr
        mesa-demos # For glxinfo
      ]
      ++ additionalBinaries;
    in
    [
      "--prefix POLYMC_JAVA_PATHS : ${lib.makeSearchPath "bin/java" jdks}"
      "--set LD_LIBRARY_PATH ${addDriverRunpath.driverLink}/lib:${lib.makeLibraryPath runtimeLibs}:${mangohud}/lib/mangohud"
      "--prefix PATH : ${lib.makeBinPath runtimeBins}"
    ];
}
