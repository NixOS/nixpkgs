{ stdenv
, lib
, fetchpatch
, pkg-config
, cmake
, bluez
, ffmpeg
, libao
, gtk3
, glib
, libGLU
, libGL
, gettext
, libpthreadstubs
, libXrandr
, libXext
, readline
, openal
, libXdmcp
, portaudio
, fetchFromGitHub
, libusb1
, libevdev
, wxGTK30
, soundtouch
, miniupnpc
, mbedtls_2
, curl
, lzo
, sfml
, libpulseaudio ? null
}:

stdenv.mkDerivation rec {
  pname = "dolphin-emu";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "dolphin-emu";
    repo = "dolphin";
    rev = version;
    sha256 = "07mlfnh0hwvk6xarcg315x7z2j0qbg9g7cm040df9c8psiahc3g6";
  };

  patches = [
    # Fix FTBFS with glibc 2.26
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/dolphin-emu/raw/8c952b1fcd46259e9d8cce836df433e0a8b88f8c/debian/patches/02_glibc-2.26.patch";
      name = "02_glibc-2.26.patch";
      sha256 = "sha256-LBXT3rf5klwmX9YQXt4/iv06GghsWZprNhLGYlKiDqk=";
    })
    # Fix FTBFS with GCC 8
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/dolphin-emu/raw/8c952b1fcd46259e9d8cce836df433e0a8b88f8c/debian/patches/03_gcc8.patch";
      name = "03_gcc8.patch";
      sha256 = "sha256-uWP6zMjoHYbX6K+oPSQdBn2xWQpvNyhZabMkhtYrSbU=";
    })
    # Fix FTBFS with SoundTouch 2.1.2
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/dolphin-emu/raw/8c952b1fcd46259e9d8cce836df433e0a8b88f8c/debian/patches/05_soundtouch-2.1.2.patch";
      name = "05_soundtouch-2.1.2.patch";
      sha256 = "sha256-Y7CNM6GQC9GRhlOBLZlxkIpj1CFhIwA5L8lGXur/bwY=";
    })
    # Use GTK+3 wxWidgets backend
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/dolphin-emu/raw/8c952b1fcd46259e9d8cce836df433e0a8b88f8c/debian/patches/06_gtk3.patch";
      name = "06_gtk3.patch";
      sha256 = "sha256-pu5Q0+8kNwmpf2DoXCXHFqxF0EGTnFXJipkBz1Vh2cs=";
    })
  ];

  cmakeFlags = [
    "-DENABLE_LTO=True"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    bluez
    ffmpeg
    libao
    libGLU
    libGL
    gtk3
    glib
    gettext
    libpthreadstubs
    libXrandr
    libXext
    readline
    openal
    libevdev
    libXdmcp
    portaudio
    libpulseaudio
    libevdev
    libXdmcp
    portaudio
    libusb1
    libpulseaudio
    wxGTK30
    soundtouch
    miniupnpc
    mbedtls_2
    curl
    lzo
    sfml
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -D $src/Data/51-usb-device.rules $out/etc/udev/rules.d/51-usb-device.rules
  '';

  meta = with lib; {
    homepage = "https://dolphin-emu.org/";
    description = "Gamecube/Wii/Triforce emulator for x86_64 and ARMv8";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ MP2E ashkitten ];
    # x86_32 is an unsupported platform.
    # Enable generic build if you really want a JIT-less binary.
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
