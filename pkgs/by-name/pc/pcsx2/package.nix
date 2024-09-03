{
  lib,
  SDL2,
  callPackage,
  cmake,
  cubeb,
  curl,
  extra-cmake-modules,
  ffmpeg,
  libXrandr,
  libaio,
  libbacktrace,
  libpcap,
  libwebp,
  llvmPackages_17,
  lz4,
  makeWrapper,
  pkg-config,
  qt6,
  soundtouch,
  strip-nondeterminism,
  vulkan-headers,
  vulkan-loader,
  wayland,
  zip,
  zstd,
}:

let
  sources = callPackage ./sources.nix { };
  inherit (qt6)
    qtbase
    qtsvg
    qttools
    qtwayland
    wrapQtAppsHook
    ;
in
llvmPackages_17.stdenv.mkDerivation (finalAttrs: {
  inherit (sources.pcsx2) pname version src;

  patches = [
    # Remove PCSX2_GIT_REV
    ./0000-define-rev.patch
  ];

  cmakeFlags = [
    (lib.cmakeBool "DISABLE_ADVANCE_SIMD" true)
    (lib.cmakeBool "USE_LINKED_FFMPEG" true)
    (lib.cmakeFeature "PCSX2_GIT_REV" finalAttrs.src.rev)
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    strip-nondeterminism
    wrapQtAppsHook
    zip
  ];

  buildInputs = [
    curl
    extra-cmake-modules
    ffmpeg
    libaio
    libbacktrace
    libpcap
    libwebp
    libXrandr
    lz4
    qtbase
    qtsvg
    qttools
    qtwayland
    SDL2
    sources.shaderc-patched
    soundtouch
    vulkan-headers
    wayland
    zstd
  ] ++ cubeb.passthru.backendLibs;

  strictDeps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -a bin/pcsx2-qt bin/resources $out/bin/

    install -Dm644 $src/pcsx2-qt/resources/icons/AppIcon64.png $out/share/pixmaps/PCSX2.png
    install -Dm644 $src/.github/workflows/scripts/linux/pcsx2-qt.desktop $out/share/applications/PCSX2.desktop

    zip -jq $out/bin/resources/patches.zip ${sources.pcsx2_patches.src}/patches/*
    strip-nondeterminism $out/bin/resources/patches.zip
    runHook postInstall
  '';

  qtWrapperArgs =
    let
      libs = lib.makeLibraryPath (
        [
          vulkan-loader
          sources.shaderc-patched
        ]
        ++ cubeb.passthru.backendLibs
      );
    in
    [ "--prefix LD_LIBRARY_PATH : ${libs}" ];

  # https://github.com/PCSX2/pcsx2/pull/10200
  # Can't avoid the double wrapping, the binary wrapper from qtWrapperArgs doesn't support --run
  postFixup = ''
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/pcsx2-qt \
      --run 'if [[ -z $I_WANT_A_BROKEN_WAYLAND_UI ]]; then export QT_QPA_PLATFORM=xcb; fi'
  '';

  meta = {
    homepage = "https://pcsx2.net";
    description = "Playstation 2 emulator";
    longDescription = ''
      PCSX2 is an open-source PlayStation 2 (AKA PS2) emulator. Its purpose is
      to emulate the PS2 hardware, using a combination of MIPS CPU Interpreters,
      Recompilers and a Virtual Machine which manages hardware states and PS2
      system memory. This allows you to play PS2 games on your PC, with many
      additional features and benefits.
    '';
    changelog = "https://github.com/PCSX2/pcsx2/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/PCSX2/pcsx2";
    license = with lib.licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    mainProgram = "pcsx2-qt";
    maintainers = with lib.maintainers; [
      AndersonTorres
      hrdinka
      govanify
      matteopacini
    ];
    platforms = lib.systems.inspect.patternLogicalAnd
      lib.systems.inspect.patterns.isLinux
      lib.systems.inspect.patterns.isx86_64;
  };
})
