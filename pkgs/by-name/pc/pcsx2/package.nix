{
  lib,
  fetchFromGitHub,
  sdl3,
  cmake,
  cubeb,
  curl,
  kdePackages,
  ffmpeg,
  gtk3,
  libxrandr,
  libaio,
  libbacktrace,
  libpcap,
  libwebp,
  llvmPackages,
  lz4,
  pkg-config,
  qt6,
  rapidyaml,
  shaderc,
  soundtouch,
  strip-nondeterminism,
  vulkan-headers,
  vulkan-loader,
  wayland,
  wrapGAppsHook3,
  zip,
  zstd,
  plutovg,
  plutosvg,
  kddockwidgets,
}:

let
  pcsx2_patches = fetchFromGitHub {
    owner = "PCSX2";
    repo = "pcsx2_patches";
    rev = "57e7089511430020ad9a8b22c6d27a593057d50a";
    hash = "sha256-tua44ywpqCsbMMhS8G5K4nJJyQNIUvB35EBkTf7WurI=";
  };

  inherit (qt6)
    qtbase
    qtsvg
    qttools
    qtwayland
    wrapQtAppsHook
    ;
in
llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "pcsx2";
  version = "2.8.2";
  src = fetchFromGitHub {
    pname = "pcsx2-source";
    owner = "PCSX2";
    repo = "pcsx2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sXVeOTVkd/c04M6BduPl34inqSUoJwfJoWCvpFdR4VQ=";
  };

  patches = [
    ./remove-cubeb-vendor.patch
  ];

  postPatch = ''
    substituteInPlace cmake/Pcsx2Utils.cmake \
      --replace-fail 'set(PCSX2_GIT_TAG "")' 'set(PCSX2_GIT_TAG "${finalAttrs.src.tag}")'
  '';

  cmakeFlags = [
    (lib.cmakeBool "PACKAGE_MODE" true)
    (lib.cmakeBool "DISABLE_ADVANCE_SIMD" true)
    (lib.cmakeBool "USE_LINKED_FFMPEG" true)
  ];

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    pkg-config
    strip-nondeterminism
    wrapGAppsHook3
    wrapQtAppsHook
    zip
  ];

  buildInputs = [
    kdePackages.extra-cmake-modules
    curl
    ffmpeg
    gtk3
    libaio
    libbacktrace
    libpcap
    libwebp
    libxrandr
    lz4
    qtbase
    qtsvg
    qttools
    qtwayland
    sdl3
    plutovg
    plutosvg
    kddockwidgets
    rapidyaml
    shaderc
    soundtouch
    vulkan-headers
    wayland
    zstd
    cubeb
  ];

  strictDeps = true;

  postInstall = ''
    install -Dm644 $src/pcsx2-qt/resources/icons/AppIcon64.png $out/share/icons/hicolor/64x64/apps/PCSX2.png
    install -Dm644 $src/.github/workflows/scripts/linux/pcsx2-qt.desktop $out/share/applications/PCSX2.desktop

    zip -jq $out/share/PCSX2/resources/patches.zip ${pcsx2_patches}/patches/*
    strip-nondeterminism $out/share/PCSX2/resources/patches.zip
  '';

  qtWrapperArgs =
    let
      libs = lib.makeLibraryPath [
        vulkan-loader
        shaderc
      ];
    in
    [ "--prefix LD_LIBRARY_PATH : ${libs}" ];

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    inherit pcsx2_patches;
    updateScript.command = [ ./update.sh ];
  };

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
      _0david0mp
      govanify
      matteopacini
    ];
    platforms = lib.systems.inspect.patternLogicalAnd lib.systems.inspect.patterns.isLinux lib.systems.inspect.patterns.isx86_64;
  };
})
