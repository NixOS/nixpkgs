{
  lib,
  fetchFromGitHub,
  sdl3,
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
  llvmPackages,
  lz4,
  makeWrapper,
  pkg-config,
  qt6,
  shaderc,
  soundtouch,
  strip-nondeterminism,
  vulkan-headers,
  vulkan-loader,
  wayland,
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
    rev = "49d2f7bb0b4387e9cb7c68233e2bdc156850542b";
    hash = "sha256-WByW40lf5h1hlnxxiiP9WyEhk8NwxATZDguWQj+j3iA=";
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
  version = "2.3.407";
  src = fetchFromGitHub {
    pname = "pcsx2-source";
    owner = "PCSX2";
    repo = "pcsx2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3/nnGdEr7flA8g9jPC8clAyvZlwQh12/YH4+t0O9OuU=";
  };

  patches = [
    # Remove PCSX2_GIT_REV
    ./0000-define-rev.patch

    ./remove-cubeb-vendor.patch
  ];

  cmakeFlags = [
    (lib.cmakeBool "PACKAGE_MODE" true)
    (lib.cmakeBool "DISABLE_ADVANCE_SIMD" true)
    (lib.cmakeBool "USE_LINKED_FFMPEG" true)
    (lib.cmakeFeature "PCSX2_GIT_REV" finalAttrs.src.tag)
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    strip-nondeterminism
    wrapQtAppsHook
    zip
  ];

  buildInputs = [
    curl
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
    sdl3
    plutovg
    plutosvg
    kddockwidgets
    shaderc
    soundtouch
    vulkan-headers
    wayland
    zstd
    cubeb
  ];

  strictDeps = true;

  postInstall = ''
    install -Dm644 $src/pcsx2-qt/resources/icons/AppIcon64.png $out/share/pixmaps/PCSX2.png
    install -Dm644 $src/.github/workflows/scripts/linux/pcsx2-qt.desktop $out/share/applications/PCSX2.desktop

    zip -jq $out/share/PCSX2/resources/patches.zip ${pcsx2_patches}/patches/*
    strip-nondeterminism $out/share/PCSX2/resources/patches.zip
  '';

  qtWrapperArgs =
    let
      libs = lib.makeLibraryPath ([
        vulkan-loader
        shaderc
      ]);
    in
    [ "--prefix LD_LIBRARY_PATH : ${libs}" ];

  # https://github.com/PCSX2/pcsx2/pull/10200
  # Can't avoid the double wrapping, the binary wrapper from qtWrapperArgs doesn't support --run
  postFixup = ''
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/pcsx2-qt \
      --run 'if [[ -z $I_WANT_A_BROKEN_WAYLAND_UI ]]; then export QT_QPA_PLATFORM=xcb; fi'
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
      hrdinka
      govanify
      matteopacini
    ];
    platforms = lib.systems.inspect.patternLogicalAnd lib.systems.inspect.patterns.isLinux lib.systems.inspect.patterns.isx86_64;
  };
})
