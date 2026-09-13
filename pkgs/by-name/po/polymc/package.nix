{
  stdenv,
  lib,
  symlinkJoin,
  addDriverRunpath,

  msaClientID ? null,
  msaRequired ? true,
  enableLTO ? false,
  gamemodeSupport ? stdenv.isLinux,
  mangohudSupport ? stdenv.isLinux,

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
  qt6,
  mesa-demos,
  gamemode,
  mangohud,

  libx11,
  libxext,
  libxcursor,
  libxrandr,
  libxxf86vm,
  xrandr,

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

    It's set to true by default to avoid any piracy-related discussion.
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
  inherit (polymc) version;

  paths = [ polymc ];
  nativeBuildInputs = [ qt6.wrapQtAppsHook ];
  buildInputs = with qt6; [
    qtbase
    qtwayland
  ];

  postBuild = "wrapQtAppsHook";

  strictDeps = true;
  __structuredAttrs = true;

  qtWrapperArgs =
    let
      runtimeLibs = [
        # xorg
        libx11
        libxext
        libxcursor
        libxrandr
        libxxf86vm

        libpulseaudio
        libGL
        glfw
        openal
        stdenv.cc.cc.lib

        vulkan-loader # VulkanMod's lwjgl
      ]
      ++ additionalLibraries
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        wayland
        udev # OSHI
      ]
      ++ lib.optional gamemodeSupport gamemode.lib;

      runtimeBins = [
        xrandr # Required by old LWJGL versions
        mesa-demos # For glxinfo
      ]
      ++ additionalBinaries;
    in
    [
      "--prefix"
      "POLYMC_JAVA_PATHS"
      ":"
      (lib.makeSearchPath "bin/java" jdks)
    ]

    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "--set"
      "LD_LIBRARY_PATH"
      "${addDriverRunpath.driverLink}/lib:${lib.makeLibraryPath runtimeLibs}${
        if mangohudSupport then ":${mangohud}/lib/mangohud" else ""
      }"
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath runtimeBins)
    ];

  meta = {
    inherit (polymc.meta)
      homepage
      downloadPage
      changelog
      description
      longDescription
      platforms
      license
      maintainers
      ;
  };
}
