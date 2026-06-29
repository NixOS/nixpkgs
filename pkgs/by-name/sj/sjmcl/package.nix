{
  addDriverRunpath,
  alsa-lib,
  desktop-file-utils,
  flite,
  gamemode,
  glfw3-minecraft,
  glib-networking,
  jdk17,
  jdk21,
  jdk25,
  jdk8,
  lib,
  libGL,
  libjack2,
  libpulseaudio,
  libusb1,
  libx11,
  libxcursor,
  libxext,
  libxrandr,
  libxxf86vm,
  openal,
  pciutils,
  pipewire,
  sjmcl-unwrapped,
  stdenv,
  symlinkJoin,
  udev,
  vulkan-loader,
  wrapGAppsHook3,
  xrandr,

  additionalLibs ? [ ],
  additionalPrograms ? [ ],
  jdks ? [
    jdk25
    jdk21
    jdk17
    jdk8
  ],
}:

let

  runtimeLibs = [
    # openal
    alsa-lib
    libjack2
    libpulseaudio
    openal
    pipewire

    # glfw
    glfw3-minecraft
    libGL
    libx11
    libxcursor
    libxext
    libxrandr
    libxxf86vm

    addDriverRunpath.driverLink
    flite # narrator support
    gamemode.lib # gamemode support
    glib-networking # Tauri
    (lib.getLib stdenv.cc.cc) # lwjgl
    libusb1 # controller support
    udev # oshi
    vulkan-loader # VulkanMod's lwjgl
  ]
  ++ additionalLibs;

  runtimePrograms = [
    desktop-file-utils # Tauri
    pciutils # need lspci
    xrandr # needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
  ]
  ++ additionalPrograms;

in

symlinkJoin {
  pname = "sjmcl";
  inherit (sjmcl-unwrapped) version;

  paths = [ sjmcl-unwrapped ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    wrapGAppsHook3
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
  ];

  postBuild = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath jdks}
      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        --set-default APPIMAGE SJMCL
        --set LD_LIBRARY_PATH ${lib.makeLibraryPath runtimeLibs}
        --prefix PATH : ${lib.makeBinPath runtimePrograms}
      ''}
    )

    glibPostInstallHook
    gappsWrapperArgsHook
    wrapGAppsHook
  '';

  meta = {
    inherit (sjmcl-unwrapped.meta)
      description
      homepage
      changelog
      license
      maintainers
      mainProgram
      platforms
      ;
  };
}
