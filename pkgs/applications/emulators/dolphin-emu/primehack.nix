{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, wrapQtAppsHook
, qtbase
, bluez
, ffmpeg
, libao
, libGLU
, libGL
, pcre
, gettext
, libXrandr
, libusb1
, lzo
, libpthreadstubs
, libXext
, libXxf86vm
, libXinerama
, libSM
, libXdmcp
, readline
, openal
, udev
, libevdev
, portaudio
, curl
, alsa-lib
, miniupnpc
, enet
, mbedtls
, soundtouch
, sfml
, fmt
, vulkan-loader
, libpulseaudio

# - Inputs used for Darwin
, CoreBluetooth
, ForceFeedback
, IOKit
, OpenGL
, libpng
, hidapi
}:

stdenv.mkDerivation rec {
  pname = "dolphin-emu-primehack";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "shiiion";
    repo = "dolphin";
    rev = version;
    sha256 = "011qghswgh9l7k993lfn1hrwhgyrv9m33smgspsjq50jww6r27fl";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ] ++ lib.optional stdenv.isLinux wrapQtAppsHook;

  buildInputs = [
    curl
    ffmpeg
    libao
    libGLU
    libGL
    pcre
    gettext
    libpthreadstubs
    libpulseaudio
    libXrandr
    libXext
    libXxf86vm
    libXinerama
    libSM
    readline
    openal
    libXdmcp
    lzo
    portaudio
    libusb1
    libpng
    hidapi
    miniupnpc
    enet
    mbedtls
    soundtouch
    sfml
    fmt
    qtbase
  ] ++ lib.optionals stdenv.isLinux [
    bluez
    udev
    libevdev
    alsa-lib
    vulkan-loader
  ] ++ lib.optionals stdenv.isDarwin [
    CoreBluetooth
    OpenGL
    ForceFeedback
    IOKit
  ];

  cmakeFlags = [
    "-DUSE_SHARED_ENET=ON"
    "-DENABLE_LTO=ON"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DOSX_USE_DEFAULT_SEARCH_PATH=True"
  ];

  qtWrapperArgs = lib.optionals stdenv.isLinux [
    "--prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib"
    # https://bugs.dolphin-emu.org/issues/11807
    # The .desktop file should already set this, but Dolphin may be launched in other ways
    "--set QT_QPA_PLATFORM xcb"
  ];

  # - Allow Dolphin to use nix-provided libraries instead of building them
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace 'DISTRIBUTOR "None"' 'DISTRIBUTOR "NixOS"'
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace CMakeLists.txt --replace 'if(NOT APPLE)' 'if(true)'
    substituteInPlace CMakeLists.txt --replace 'if(LIBUSB_FOUND AND NOT APPLE)' 'if(LIBUSB_FOUND)'
  '';

  postInstall = ''
    mv $out/bin/dolphin-emu $out/bin/dolphin-emu-primehack
    mv $out/bin/dolphin-emu-nogui $out/bin/dolphin-emu-primehack-nogui
    mv $out/share/applications/dolphin-emu.desktop $out/share/applications/dolphin-emu-primehack.desktop
    mv $out/share/icons/hicolor/256x256/apps/dolphin-emu.png $out/share/icons/hicolor/256x256/apps/dolphin-emu-primehack.png
    substituteInPlace $out/share/applications/dolphin-emu-primehack.desktop --replace 'dolphin-emu' 'dolphin-emu-primehack'
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -D $src/Data/51-usb-device.rules $out/etc/udev/rules.d/51-usb-device.rules
  '';

  meta = with lib; {
    homepage = "https://github.com/shiiion/dolphin";
    description = "Gamecube/Wii/Triforce emulator for x86_64 and ARMv8";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ MP2E ashkitten Madouura ];
    # x86_32 is an unsupported platform.
    # Enable generic build if you really want a JIT-less binary.
    broken = stdenv.isDarwin;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
