{ cmake
, fetchFromGitHub
, lib
, stdenv
, curl
, ffmpeg
, fmt
, gettext
, harfbuzz
, libaio
, libbacktrace
, libpcap
, libpulseaudio
, libsamplerate
, libXrandr
, libzip
, pkg-config
, qtbase
, qtsvg
, qttools
, qttranslations
, qtwayland
, rapidyaml
, SDL2
, soundtouch
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
    rev = "8db5ae467a35cc00dc50a65061aa78dc5115e6d1";
    sha256 = "sha256-68kD7IAhBMASFmkGwvyQ7ppO/3B1csAKik+rU792JI4=";
  };
in
stdenv.mkDerivation rec {
  pname = "pcsx2";
  version = "1.7.4554";

  src = fetchFromGitHub {
    owner = "PCSX2";
    repo = "pcsx2";
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "sha256-9MRbpm7JdVmZwv8zD4lErzVTm7A4tYM0FgXE9KpX+/8=";
  };

  cmakeFlags = [
    "-DDISABLE_ADVANCE_SIMD=TRUE"
    "-DUSE_SYSTEM_LIBS=ON"
    "-DDISABLE_BUILD_DATE=TRUE"
  ];

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook zip ];

  buildInputs = [
    curl
    ffmpeg
    fmt
    gettext
    harfbuzz
    libaio
    libbacktrace
    libpcap
    libpulseaudio
    libsamplerate
    libXrandr
    libzip
    qtbase
    qtsvg
    qttools
    qttranslations
    qtwayland
    rapidyaml
    SDL2
    soundtouch
    vulkan-headers
    vulkan-loader
    wayland
    xz
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -a bin/pcsx2-qt bin/resources $out/bin/

    install -Dm644 $src/pcsx2/Resources/AppIcon64.png $out/share/pixmaps/PCSX2.png
    install -Dm644 $src/.github/workflows/scripts/linux/pcsx2-qt.desktop $out/share/applications/PCSX2.desktop

    zip -jq $out/bin/resources/patches.zip ${pcsx2_patches}/patches/*
  '';

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
      ffmpeg # It's loaded with dlopen. They plan to change it https://github.com/PCSX2/pcsx2/issues/8624
      libpulseaudio
      vulkan-loader
    ]}"
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
