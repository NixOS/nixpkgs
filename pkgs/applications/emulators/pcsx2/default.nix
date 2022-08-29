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
  version = "1.7.3165";

  src = fetchFromGitHub {
    owner = "PCSX2";
    repo = "pcsx2";
    fetchSubmodules = true;
    rev = "v${version}";
    hash = "sha256-FdLmLZLpS8zPmHVn4k0nE6vS/omYVIOal9ej0h3bE/Y=";
  };

  cmakeFlags = [
    "-DDISABLE_ADVANCE_SIMD=TRUE"
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

  # Wayland doesn't seem to work right now (crashes when booting a game).
  # Try removing `--prefix GDK_BACKEND : x11` on the next update.
  # (This may be solved when the project finshes migrating to Qt)
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
      --prefix GDK_BACKEND : x11
    )
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
    maintainers = with maintainers; [ hrdinka govanify ];

    # PCSX2's source code is released under LGPLv3+. It However ships
    # additional data files and code that are licensed differently.
    # This might be solved in future, for now we should stick with
    # license.free
    license = licenses.free;
    platforms = platforms.x86_64;
  };
}
