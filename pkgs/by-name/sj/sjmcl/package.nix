{
  lib,
  stdenv,
  symlinkJoin,
  makeWrapper,
  sjmcl-unwrapped,
  hicolor-icon-theme,
  desktop-file-utils,
  zenity,
  glfw3-minecraft,
  openal,
  alsa-lib,
  libjack2,
  libpulseaudio,
  pipewire,
  libGL,
  libx11,
  libxcursor,
  libxext,
  libxrandr,
  libxxf86vm,
  udev,
  vulkan-loader,
  flite,
  gamemode,
  libusb1,
  additionalLibs ? [ ],
  additionalPrograms ? [ ],
  controllerSupport ? stdenv.hostPlatform.isLinux,
  gamemodeSupport ? stdenv.hostPlatform.isLinux,
  textToSpeechSupport ? stdenv.hostPlatform.isLinux,
  jdks ? [ jdk ],
  jdk,
}:
let
  sjmcl' = sjmcl-unwrapped;
  runtimeBin = [
    desktop-file-utils
    zenity
  ]
  ++ additionalPrograms;
  runtimeLib = [
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
    libx11
    libxcursor
    libxext
    libxrandr
    libxxf86vm

    udev # oshi

    vulkan-loader # VulkanMod's lwjgl
  ]
  ++ lib.optional textToSpeechSupport flite
  ++ lib.optional gamemodeSupport gamemode.lib
  ++ lib.optional controllerSupport libusb1
  ++ additionalLibs;
in
symlinkJoin {
  pname = "sjmcl";
  inherit (sjmcl') version meta;

  paths = [
    sjmcl'
    hicolor-icon-theme
  ];

  nativeBuildInputs = [
    makeWrapper
  ];
  buildInputs = [
    desktop-file-utils
    hicolor-icon-theme
  ];

  postBuild = ''
    wrapProgram $out/bin/SJMCL \
      --prefix PATH : "${lib.makeBinPath (jdks ++ runtimeBin)}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLib}"
  '';
}
