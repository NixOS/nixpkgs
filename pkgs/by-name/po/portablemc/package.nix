{
  lib,
  stdenv,
  fetchFromGitHub,

  rustPlatform,
  pkg-config,
  openssl,

  makeWrapper,

  addDriverRunpath,
  alsa-lib,
  glfw3-minecraft,
  libGL,
  libjack2,
  libpulseaudio,
  libX11,
  libXcursor,
  libXext,
  libXrandr,
  libXxf86vm,
  openal,
  pipewire,
  udev,
  vulkan-loader,

  textToSpeechSupport ? stdenv.hostPlatform.isLinux,
  flite,

  mesa-demos,
  pciutils,
  xrandr,

  jdk8,
  jdk17,
  jdk21,
  jdk25,

  # can be overriden to reduce the closure size
  jvms ? [
    jdk8
    jdk17
    jdk21
    jdk25
  ],

  additionalLibs ? [ ],
  additionalPrograms ? [ ],
}:

let
  # Copied from the `prismlauncher` package
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
    libX11
    libXcursor
    libXext
    libXrandr
    libXxf86vm

    udev # oshi

    vulkan-loader # VulkanMod's lwjgl
  ]
  ++ lib.optional textToSpeechSupport flite
  ++ additionalLibs;

  # Copied from the `prismlauncher` package
  runtimePrograms = [
    mesa-demos
    pciutils # need lspci
    xrandr # needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
  ]
  ++ jvms
  ++ additionalPrograms;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "portablemc";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "mindstorm38";
    repo = "portablemc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J8FuGe5qqJgs7e2TMMROZBtd+HmO/hlIGcqAb81Sm7I=";
  };

  dontUnpack = true;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-O8EyFX0ZeUkeHqPimU6I25EwM02WSn9pWcf4qrM5Pts=";
  };

  unwrapped = rustPlatform.buildRustPackage {
    name = "portablemc-${finalAttrs.version}-unwrapped";
    inherit (finalAttrs) src cargoDeps;

    nativeBuildInputs = [ pkg-config ];

    buildInputs = [ openssl ];
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    makeWrapper "$unwrapped/bin/portablemc" "$out/bin/portablemc" \
      --prefix LD_LIBRARY_PATH : ${addDriverRunpath.driverLink}/lib:${lib.makeLibraryPath runtimeLibs} \
      --prefix PATH : ${lib.makeBinPath runtimePrograms}

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/mindstorm38/portablemc";
    description = "Cross platform command line utility for launching Minecraft quickly and reliably with included support for Mojang versions and popular mod loaders";
    changelog = "https://github.com/mindstorm38/portablemc/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "portablemc";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})
