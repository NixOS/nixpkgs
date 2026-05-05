# adapted from prismlauncher's wrapper, since they both include libs for
# launching minecraft. I can't do `prismlauncher.override
# { prismlauncher-unwrapped = pandora-launcher-unwrapped; }` though, since
# pandora isn't a QT app (and most likely future subtle differences).
{
  addDriverRunpath,
  alsa-lib,
  flite,
  gamemode,
  glfw3-minecraft,
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
  makeWrapper,
  openal,
  pandora-launcher-unwrapped,
  pciutils,
  pipewire,
  stdenv,
  symlinkJoin,
  udev,
  vulkan-loader,
  xrandr,

  additionalLibs ? [ ],
  additionalPrograms ? [ ],
  controllerSupport ? stdenv.hostPlatform.isLinux,
  gamemodeSupport ? stdenv.hostPlatform.isLinux,
  jdks ? [
    jdk25
    jdk21
    jdk17
    jdk8
  ],
  msaClientID ? null,
  textToSpeechSupport ? stdenv.hostPlatform.isLinux,
}:

assert lib.assertMsg (
  controllerSupport -> stdenv.hostPlatform.isLinux
) "controllerSupport only has an effect on Linux.";

assert lib.assertMsg (
  textToSpeechSupport -> stdenv.hostPlatform.isLinux
) "textToSpeechSupport only has an effect on Linux.";

let
  pandora-launcher' = pandora-launcher-unwrapped.override { inherit msaClientID; };
in

symlinkJoin {
  pname = "pandora-launcher";
  inherit (pandora-launcher') version;

  strictDeps = true;
  # breaks symlinkJoin
  # tracked in https://github.com/NixOS/nixpkgs/issues/510434
  # __structuredAttrs = true;

  paths = [ pandora-launcher' ];

  nativeBuildInputs = [ makeWrapper ];

  makeWrapperArgs =
    let
      runtimeLibs = [

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

      runtimePrograms = [
        pciutils # need lspci
        xrandr # needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
      ]
      ++ additionalPrograms;

    in
    [
      "--prefix"
      "FORCE_EXTERNAL_JAVA"
      ":"
      (lib.concatStringsSep ":" (map (jdk: jdk.home) jdks))
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "--set"
      "LD_LIBRARY_PATH"
      "${addDriverRunpath.driverLink}/lib:${lib.makeLibraryPath runtimeLibs}"

      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath runtimePrograms)
    ];

  postBuild = ''
    wrapProgram $out/bin/pandora_launcher $makeWrapperArgs
  '';

  meta = {
    inherit (pandora-launcher'.meta)
      description
      homepage
      license
      maintainers
      mainProgram
      ;
  };
}
