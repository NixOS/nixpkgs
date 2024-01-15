{ cmake
, fetchFromGitHub
, lib
, llvmPackages_17
, cubeb
, curl
, extra-cmake-modules
, ffmpeg
, gettext
, harfbuzz
, libaio
, libbacktrace
, libpcap
, libsamplerate
, libXrandr
, libzip
, makeWrapper
, pkg-config
, qtbase
, qtsvg
, qttools
, qtwayland
, SDL2
, soundtouch
, strip-nondeterminism
, vulkan-headers
, vulkan-loader
, wayland
, wrapQtAppsHook
, xz
, zip
}:

let
  # The pre-zipped files in releases don't have a versioned link, we need to zip them ourselves
  pcsx2_patches = fetchFromGitHub {
    owner = "PCSX2";
    repo = "pcsx2_patches";
    rev = "42d7ee72b66955e3bbd2caaeaa855f605b463722";
    sha256 = "sha256-Zd+Aeps2IWVX2fS1Vyczv/wAX8Z89XnCH1eqSPdYEw8=";
  };
in
llvmPackages_17.stdenv.mkDerivation rec {
  pname = "pcsx2";
  version = "1.7.5318";

  src = fetchFromGitHub {
    owner = "PCSX2";
    repo = "pcsx2";
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "sha256-5SUlq3HQAzROG1yncA4u4XGVv+1I+s9FQ6LgJkiLSD0=";
  };

  cmakeFlags = [
    "-DDISABLE_ADVANCE_SIMD=ON"
    "-DUSE_LINKED_FFMPEG=ON"
    "-DDISABLE_BUILD_DATE=ON"
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
    gettext
    harfbuzz
    libaio
    libbacktrace
    libpcap
    libsamplerate
    libXrandr
    libzip
    qtbase
    qtsvg
    qttools
    qtwayland
    SDL2
    soundtouch
    vulkan-headers
    vulkan-loader
    wayland
    xz
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
    license = with licenses; [ gpl3 lgpl3 ];
    maintainers = with maintainers; [ hrdinka govanify ];
    mainProgram = "pcsx2-qt";
    platforms = platforms.x86_64;
  };
}
