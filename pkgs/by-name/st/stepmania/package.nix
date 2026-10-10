{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nasm,
  perl,
  pkg-config,
  copyDesktopItems,
  desktopToDarwinBundle,
  unstableGitUpdater,
  alsa-lib,
  glib,
  gtk3,
  libpulseaudio,
  libusb-compat-0_1,
  udev,
  libxtst,
  libx11,
  libxinerama,
  libxrandr,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stepmania";
  # 5.1.0-b2 is last tag (2018-07-24). Upstream is active on 5_1-new; track latest with macOS 11+ and ffmpeg-7 fixes.
  version = "5.1.0-b2-unstable-2026-08-22";

  src = fetchFromGitHub {
    owner = "stepmania";
    repo = "stepmania";
    rev = "825467bcd81c812b33ad684dc04dd151b2d5dec3";
    hash = "sha256-FgsmRG65WsZw84MtJkyUVJYb36+6lc7jVpQKdIWkP/A=";
    fetchSubmodules = true;
  };

  postPatch =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Bundled ffmpeg's configure defaults to `gcc`, which is absent on Nix darwin
      substituteInPlace CMake/SetupFfmpeg.cmake \
        --replace-fail '"--enable-static"' '"--enable-static" "--cc=clang" "--cxx=clang++" "--ld=clang"'
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      # Upstream passes the pkg-config result name instead of the find_package
      # name, which triggers a developer warning with newer CMake versions :(
      substituteInPlace CMake/Modules/FindPulseAudio.cmake \
        --replace-fail 'find_package_handle_standard_args(PULSEAUDIO' 'find_package_handle_standard_args(PulseAudio'
    '';

  __structuredAttrs = true;
  strictDeps = true;

  cmakeBuildDir = "Build";

  # Bundled ffmpeg/minimp3 use text relocations and legacy flags; Darwin hardening rejects them.
  hardeningDisable = lib.optionals stdenv.hostPlatform.isDarwin [ "all" ];

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    nasm
    perl
    pkg-config
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  # These keep upstream's default-enabled Linux display, audio, input, and
  # PacDrive support; the corresponding options do not exist on Darwin.
  buildInputs = [
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    glib
    gtk3
    libpulseaudio
    libusb-compat-0_1
    udev
    libxtst
    libx11
    libxrandr
    libxinerama
  ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "CMAKE_OSX_ARCHITECTURES" stdenv.hostPlatform.darwinArch)
    (lib.cmakeFeature "CMAKE_SYSTEM_PROCESSOR" stdenv.hostPlatform.parsed.cpu.name)
  ];

  # Upstream enables -Werror; newer clang/gcc emit extra warnings that break the build.
  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  postInstall = ''
    mkdir -p "$out/bin" "$out/share"
    ln -s "$out/${
      if stdenv.hostPlatform.isDarwin then
        "StepMania/StepMania.app/Contents/MacOS/StepMania"
      else
        "stepmania/stepmania"
    }" "$out/bin/stepmania"
    cp -r "$src/icons" "$out/share/"
  '';

  desktopItems = [
    "${finalAttrs.src}/stepmania.desktop"
  ];

  # desktopToDarwinBundle supplies the launcher bundle; expose the resources
  # from upstream's build bundle through it.
  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    ln -s "$out/StepMania/StepMania.app/Contents/Resources/"* \
      "$out/Applications/StepMania.app/Contents/Resources/"
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/stepmania/stepmania.git";
    tagPrefix = "v";
  };

  meta = {
    homepage = "https://www.stepmania.com/";
    description = "Free dance and rhythm game for Windows, Mac, and Linux";
    longDescription = ''
      StepMania is a rhythm game supporting dance pads, keyboards, and
      controllers. This package tracks the 5_1-new branch with upstream
      fixes for ffmpeg 7 and macOS 11+.
    '';
    changelog = "https://github.com/stepmania/stepmania/commits/5_1-new";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit; # expat, bundled songs CC-NC
    maintainers = with lib.maintainers; [
      h7x4
      philocalyst
    ];
    mainProgram = "stepmania";
  };
})
