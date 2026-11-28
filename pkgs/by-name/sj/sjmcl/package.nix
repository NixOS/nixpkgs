{
  lib,
  addDriverRunpath,
  alsa-lib,
  desktop-file-utils,
  flite,
  gamemode,
  glfw3-minecraft,
  glib-networking,
  jdk,
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
  jdks ? [ jdk ],

  # Prismlauncher's apikey; Temporary fix
  apikey ? "$2a$10$wuAJuNZuted3NORVmpgUC.m8sI.pv1tOPKZyBgLFGjxFp/br0lZCC",
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

  strictDeps = true;
  __structuredAttrs = true;

  paths = [ sjmcl-unwrapped ];

  nativeBuildInputs = [ wrapGAppsHook3 ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ glib-networking ];

  postBuild = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath jdks}
      --set-default SJMCL_CURSEFORGE_API_KEY '${apikey}'
      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        --set-default APPIMAGE SJMCL
        --set LD_LIBRARY_PATH ${lib.makeLibraryPath runtimeLibs}
        --prefix PATH : ${lib.makeBinPath runtimePrograms}
      ''}
    )

    glibPostInstallHook
    gappsWrapperArgsHook
    wrapGApp $out/bin/SJMCL
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
