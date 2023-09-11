{ cmake
, fetchFromGitHub
, lib
, llvmPackages_16
, cubeb
, curl
, ffmpeg
, fmt_8
, gettext
, harfbuzz
, libaio
, libbacktrace
, libpcap
, libsamplerate
, libXrandr
, libzip
, pkg-config
, qtbase
, qtsvg
, qttools
, qtwayland
, rapidyaml
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
    rev = "c09d842168689aeba88b656e3e0a042128673a7c";
    sha256 = "sha256-h1jqv3a3Ib/4C7toZpSlVB1VFNNF1MrrUxttqKJL794=";
  };
in
llvmPackages_16.stdenv.mkDerivation rec {
  pname = "pcsx2";
  version = "1.7.4658";

  src = fetchFromGitHub {
    owner = "PCSX2";
    repo = "pcsx2";
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "sha256-5y7CYFWgNh9oCBuTITvw7Rn4sC6MbMczVMAwtWFkn9A=";
  };

  cmakeFlags = [
    "-DDISABLE_ADVANCE_SIMD=TRUE"
    "-DUSE_SYSTEM_LIBS=ON"
    "-DUSE_LINKED_FFMPEG=ON"
    "-DDISABLE_BUILD_DATE=TRUE"
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
    ffmpeg
    fmt_8
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
    rapidyaml
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

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath ([
      vulkan-loader
    ] ++ cubeb.passthru.backendLibs)}"
  ];

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
