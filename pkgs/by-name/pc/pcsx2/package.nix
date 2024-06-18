{ cmake
, fetchFromGitHub
, lib
, llvmPackages_17
, callPackage
, cubeb
, curl
, extra-cmake-modules
, fetchpatch
, ffmpeg
, libaio
, libbacktrace
, libpcap
, libwebp
, libXrandr
, lz4
, makeWrapper
, pkg-config
, qt6
, SDL2
, soundtouch
, strip-nondeterminism
, vulkan-headers
, vulkan-loader
, wayland
, zip
, zstd
}:

let
  shaderc-patched = callPackage ./shaderc-patched.nix { };
  # The pre-zipped files in releases don't have a versioned link, we need to zip them ourselves
  pcsx2_patches = fetchFromGitHub {
    owner = "PCSX2";
    repo = "pcsx2_patches";
    rev = "b3a788e16ea12efac006cbbe1ece45b6b9b34326";
    sha256 = "sha256-Uvpz2Gpj533Sr6wLruubZxssoXefQDey8GHIDKWhW3s=";
  };
  inherit (qt6)
    qtbase
    qtsvg
    qttools
    qtwayland
    wrapQtAppsHook
  ;
in
llvmPackages_17.stdenv.mkDerivation (finalAttrs: {
  pname = "pcsx2";
  version = "1.7.5779";

  src = fetchFromGitHub {
    owner = "PCSX2";
    repo = "pcsx2";
    fetchSubmodules = true;
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-WiwnP5yoBy8bRLUPuCZ7z4nhIzrY8P29KS5ZjErM/A4=";
  };

  patches = [
    ./define-rev.patch
    # Backport patches to fix random crashes on startup
    (fetchpatch {
      url = "https://github.com/PCSX2/pcsx2/commit/e47bcf8d80df9a93201eefbaf169ec1a0673a833.patch";
      sha256 = "sha256-7CL1Kpu+/JgtKIenn9rQKAs3A+oJ40W5XHlqSg77Q7Y=";
    })
    (fetchpatch {
      url = "https://github.com/PCSX2/pcsx2/commit/92b707db994f821bccc35d6eef67727ea3ab496b.patch";
      sha256 = "sha256-HWJ8KZAY/qBBotAJerZg6zi5QUHuTD51zKH1rAtZ3tc=";
    })
  ];

  cmakeFlags = [
    (lib.cmakeBool "DISABLE_ADVANCE_SIMD" true)
    (lib.cmakeBool "USE_LINKED_FFMPEG" true)
    (lib.cmakeFeature "PCSX2_GIT_REV" finalAttrs.src.rev)
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
    SDL2
    shaderc-patched
    soundtouch
    vulkan-headers
    wayland
    zstd
  ]
  ++ cubeb.passthru.backendLibs;

  installPhase = ''
    mkdir -p $out/bin
    cp -a bin/pcsx2-qt bin/resources $out/bin/

    install -Dm644 $src/pcsx2-qt/resources/icons/AppIcon64.png $out/share/pixmaps/PCSX2.png
    install -Dm644 $src/.github/workflows/scripts/linux/pcsx2-qt.desktop $out/share/applications/PCSX2.desktop

    zip -jq $out/bin/resources/patches.zip ${pcsx2_patches}/patches/*
    strip-nondeterminism $out/bin/resources/patches.zip
  '';

  qtWrapperArgs =
    let
      libs = lib.makeLibraryPath ([
        vulkan-loader
      ] ++ cubeb.passthru.backendLibs);
    in [
      "--prefix LD_LIBRARY_PATH : ${libs}"
    ];

  # https://github.com/PCSX2/pcsx2/pull/10200
  # Can't avoid the double wrapping, the binary wrapper from qtWrapperArgs doesn't support --run
  postFixup = ''
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/pcsx2-qt \
      --run 'if [[ -z $I_WANT_A_BROKEN_WAYLAND_UI ]]; then export QT_QPA_PLATFORM=xcb; fi'
  '';

  meta = with lib; {
    description = "Playstation 2 emulator";
    longDescription = ''
      PCSX2 is an open-source PlayStation 2 (AKA PS2) emulator. Its purpose
      is to emulate the PS2 hardware, using a combination of MIPS CPU
      Interpreters, Recompilers and a Virtual Machine which manages hardware
      states and PS2 system memory. This allows you to play PS2 games on your
      PC, with many additional features and benefits.
    '';
    homepage = "https://pcsx2.net";
    license = with licenses; [ gpl3Plus lgpl3Plus ];
    maintainers = with maintainers; [ hrdinka govanify ];
    mainProgram = "pcsx2-qt";
    platforms = [ "x86_64-linux" ];
  };
})
