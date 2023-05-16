<<<<<<< HEAD
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
=======
{ alsa-lib
, cmake
, fetchFromGitHub
, fmt
, gettext
, glib
, gtk3
, harfbuzz
, lib
, libaio
, libpcap
, libpng
, libpulseaudio
, libsamplerate
, libXdmcp
, openssl
, pcre
, perl
, pkg-config
, portaudio
, SDL2
, soundtouch
, stdenv
, udev
, vulkan-headers
, vulkan-loader
, wrapGAppsHook
, wxGTK
, zlib
, wayland
}:

stdenv.mkDerivation rec {
  pname = "pcsx2";
  version = "1.7.3331";
  # nixpkgs-update: no auto update
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "PCSX2";
    repo = "pcsx2";
    fetchSubmodules = true;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-5y7CYFWgNh9oCBuTITvw7Rn4sC6MbMczVMAwtWFkn9A=";
=======
    hash = "sha256-0RcmBMxKj/gnkNEjn2AUSSO1DzyNSf1lOZWPSUq6764=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cmakeFlags = [
    "-DDISABLE_ADVANCE_SIMD=TRUE"
<<<<<<< HEAD
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

=======
    "-DDISABLE_PCSX2_WRAPPER=TRUE"
    "-DPACKAGE_MODE=TRUE"
    "-DWAYLAND_API=TRUE"
    "-DXDG_STD=TRUE"
    "-DUSE_VULKAN=TRUE"
  ];

  nativeBuildInputs = [ cmake perl pkg-config vulkan-headers wrapGAppsHook ];

  buildInputs = [
    alsa-lib
    fmt
    gettext
    glib
    gtk3
    harfbuzz
    libaio
    libpcap
    libpng
    libpulseaudio
    libsamplerate
    libXdmcp
    openssl
    pcre
    portaudio
    SDL2
    soundtouch
    udev
    vulkan-loader
    wayland
    wxGTK
    zlib
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
    )
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    license = with licenses; [ gpl3 lgpl3 ];
    maintainers = with maintainers; [ hrdinka govanify ];
    mainProgram = "pcsx2-qt";
=======
    maintainers = with maintainers; [ hrdinka govanify ];

    # PCSX2's source code is released under LGPLv3+. It However ships
    # additional data files and code that are licensed differently.
    # This might be solved in future, for now we should stick with
    # license.free
    license = licenses.free;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.x86_64;
  };
}
