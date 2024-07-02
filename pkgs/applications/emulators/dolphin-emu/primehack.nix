{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, wrapQtAppsHook
, alsa-lib
, bluez
, bzip2
, cubeb
, curl
, enet
, ffmpeg
, fmt_10
, gtest
, hidapi
, libevdev
, libGL
, libiconv
, libpulseaudio
, libspng
, libusb1
, libXdmcp
, libXext
, libXrandr
, lz4
, lzo
, mbedtls_2
, miniupnpc
, openal
, pugixml
, qtbase
, qtsvg
, sfml
, udev
, vulkan-loader
, xxHash
, xz

  # Darwin-only dependencies
, CoreBluetooth
, ForceFeedback
, IOBluetooth
, IOKit
, moltenvk
, OpenGL
, VideoToolbox
}:

stdenv.mkDerivation rec {
  pname = "dolphin-emu-primehack";
  version = "1.0.7a";

  src = fetchFromGitHub {
    owner = "shiiion";
    repo = "dolphin";
    rev = version;
    sha256 = "sha256-vuTSXQHnR4HxAGGiPg5tUzfiXROU3+E9kyjH+T6zVmc=";
    fetchSubmodules = true;
  };

  patches = [
    # fix build w/ glibc-2.39
    (fetchpatch {
      url = "https://github.com/dolphin-emu/dolphin/commit/3da2e15e6b95f02f66df461e87c8b896e450fdab.patch";
      hash = "sha256-+8yGF412wQUYbyEuYWd41pgOgEbhCaezexxcI5CNehc=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    bzip2
    cubeb
    curl
    enet
    ffmpeg
    fmt_10
    gtest
    hidapi
    libiconv
    libpulseaudio
    libspng
    libusb1
    libXdmcp
    lz4
    lzo
    mbedtls_2
    miniupnpc
    #minizip-ng # Not wanting to make a mess with patches, leaving the vendored one for now
    openal
    pugixml
    qtbase
    qtsvg
    #SDL2 # Not used yet
    sfml
    xxHash
    xz
    # Causes linker errors with minizip-ng, prefer vendored. Possible reason why: https://github.com/dolphin-emu/dolphin/pull/12070#issuecomment-1677311838
    #zlib-ng
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
    bluez
    libevdev
    libGL
    libXext
    libXrandr
    # FIXME: Vendored version is newer than mgba's stable release, remove the comment on next mgba's version
    #mgba # Derivation doesn't support Darwin
    udev
    vulkan-loader
  ] ++ lib.optionals stdenv.isDarwin [
    CoreBluetooth
    ForceFeedback
    IOBluetooth
    IOKit
    moltenvk
    OpenGL
    VideoToolbox
  ];

  cmakeFlags = [
    "-DDISTRIBUTOR=NixOS"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DOSX_USE_DEFAULT_SEARCH_PATH=True"
    "-DUSE_BUNDLED_MOLTENVK=OFF"
    "-DMACOS_CODE_SIGNING=OFF"
    # Bundles the application folder into a standalone executable, so we cannot devendor libraries
    "-DSKIP_POSTPROCESS_BUNDLE=ON"
    # Needs xcode so compilation fails with it enabled. We would want the version to be fixed anyways.
    # Note: The updater isn't available on linux, so we don't need to disable it there.
    "-DENABLE_AUTOUPDATE=OFF"
  ];

  qtWrapperArgs = lib.optionals stdenv.isLinux [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}"
    # https://bugs.dolphin-emu.org/issues/11807
    # The .desktop file should already set this, but Dolphin may be launched in other ways
    "--set QT_QPA_PLATFORM xcb"
  ];

  # Use nix-provided libraries instead of submodules
  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "if(NOT APPLE)" "if(true)" \
      --replace-fail "if(LIBUSB_FOUND AND NOT APPLE)" "if(LIBUSB_FOUND)"
  '';

  # Check out https://github.com/shiiion/dolphin/pull/118
  postInstall = ''
    mv $out/bin/dolphin-emu $out/bin/dolphin-emu-primehack
    mv $out/bin/dolphin-emu-nogui $out/bin/dolphin-emu-primehack-nogui
    mv $out/share/applications/dolphin-emu.desktop $out/share/applications/dolphin-emu-primehack.desktop
    mv $out/share/icons/hicolor/256x256/apps/dolphin-emu.png $out/share/icons/hicolor/256x256/apps/dolphin-emu-primehack.png
    rm $out/share/icons/hicolor/scalable/apps/dolphin-emu.svg # https://github.com/shiiion/dolphin/issues/164
    substituteInPlace $out/share/applications/dolphin-emu-primehack.desktop --replace 'dolphin-emu' 'dolphin-emu-primehack'
    substituteInPlace $out/share/applications/dolphin-emu-primehack.desktop --replace 'Dolphin Emulator' 'PrimeHack'
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -D $src/Data/51-usb-device.rules $out/etc/udev/rules.d/51-usb-device.rules
  '';

  meta = with lib; {
    homepage = "https://github.com/shiiion/dolphin";
    description = "Gamecube/Wii/Triforce emulator for x86_64 and ARMv8";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ashkitten Madouura ];
    broken = stdenv.isDarwin;
    platforms = platforms.unix;
  };
}
