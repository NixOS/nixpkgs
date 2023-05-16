{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
, fmt_8
<<<<<<< HEAD
, gtest
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, lzo
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, mbedtls_2
, mgba
, miniupnpc
, minizip-ng
, openal
, pugixml
, qtbase
<<<<<<< HEAD
, qtsvg
, sfml
=======
, sfml
, soundtouch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, udev
, vulkan-loader
, xxHash
, xz
<<<<<<< HEAD
, zlib-ng
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Used in passthru
, common-updater-scripts
, dolphin-emu
, jq
, testers
, writeShellScript

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
  pname = "dolphin-emu";
<<<<<<< HEAD
  version = "5.0-19870";
=======
  version = "5.0-18498";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dolphin-emu";
    repo = "dolphin";
<<<<<<< HEAD
    rev = "032c77b462a220016f23c5079e71bb23e0ad2adf";
    sha256 = "sha256-TgRattksYsMGcbfu4T5mCFO9BkkHRX0NswFxGwZWjEw=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/dolphin-emu/dolphin/commit/c43c9101c07376297abbbbc40ef9a1965a1681cd.diff";
      sha256 = "sha256-yHlyG86ta76YKrJsyefvFh521dNbQOqiPOpRUVxKuZM=";
    })
    # Remove when merged https://github.com/dolphin-emu/dolphin/pull/12070
    ./find-minizip-ng.patch
  ];

  nativeBuildInputs = [
    stdenv.cc
=======
    rev = "46b99671d9158e0ca840c1d8ef249db0f321ced7";
    sha256 = "sha256-K+OF8o8I1XDLQQcsWC8p8jUuWeb+RoHlBG3cEZ1aWIU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    cmake
    pkg-config
    wrapQtAppsHook
  ];

<<<<<<< HEAD
  buildInputs = lib.optionals stdenv.isDarwin [
=======
  buildInputs = [
    bzip2
    cubeb
    curl
    enet
    ffmpeg
    fmt_8
    hidapi
    libGL
    libiconv
    libpulseaudio
    libspng
    libusb1
    libXdmcp
    mbedtls_2
    miniupnpc
    minizip-ng
    openal
    pugixml
    qtbase
    sfml
    soundtouch
    xxHash
    xz
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
    bluez
    libevdev
    libXext
    libXrandr
    mgba # Derivation doesn't support Darwin
    udev
    vulkan-loader
  ] ++ lib.optionals stdenv.isDarwin [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    CoreBluetooth
    ForceFeedback
    IOBluetooth
    IOKit
    moltenvk
    OpenGL
    VideoToolbox
<<<<<<< HEAD
  ] ++ [
    bzip2
    cubeb
    curl
    enet
    ffmpeg
    fmt_8
    gtest
    hidapi
    libiconv
    libpulseaudio
    libspng
    libusb1
    libXdmcp
    lzo
    mbedtls_2
    miniupnpc
    minizip-ng
    openal
    pugixml
    qtbase
    qtsvg
    sfml
    xxHash
    xz # LibLZMA
    zlib-ng
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
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  cmakeFlags = [
    "-DDISTRIBUTOR=NixOS"
<<<<<<< HEAD
=======
    "-DUSE_SHARED_ENET=ON"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "-DDOLPHIN_WC_REVISION=${src.rev}"
    "-DDOLPHIN_WC_DESCRIBE=${version}"
    "-DDOLPHIN_WC_BRANCH=master"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DOSX_USE_DEFAULT_SEARCH_PATH=True"
    "-DUSE_BUNDLED_MOLTENVK=OFF"
<<<<<<< HEAD
    "-DMACOS_CODE_SIGNING=OFF"
    # Bundles the application folder into a standalone executable, so we cannot devendor libraries
    "-DSKIP_POSTPROCESS_BUNDLE=ON"
    # Needs xcode so compilation fails with it enabled. We would want the version to be fixed anyways.
    # Note: The updater isn't available on linux, so we don't need to disable it there.
=======
    # Bundles the application folder into a standalone executable, so we cannot devendor libraries
    "-DSKIP_POSTPROCESS_BUNDLE=ON"
    # Needs xcode so compilation fails with it enabled. We would want the version to be fixed anyways.
    # Note: The updater isn't available on linux, so we dont need to disable it there.
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
      --replace "if(NOT APPLE)" "if(true)" \
      --replace "if(LIBUSB_FOUND AND NOT APPLE)" "if(LIBUSB_FOUND)"
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -D $src/Data/51-usb-device.rules $out/etc/udev/rules.d/51-usb-device.rules
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Only gets installed automatically if the standalone executable is used
    mkdir -p $out/Applications
    cp -r ./Binaries/Dolphin.app $out/Applications
    ln -s $out/Applications/Dolphin.app/Contents/MacOS/Dolphin $out/bin
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = dolphin-emu;
      command = "dolphin-emu-nogui --version";
    };

    updateScript = writeShellScript "dolphin-update-script" ''
      set -eou pipefail
      export PATH=${lib.makeBinPath [ curl jq common-updater-scripts ]}

      json="$(curl -s https://dolphin-emu.org/update/latest/beta)"
      version="$(jq -r '.shortrev' <<< "$json")"
      rev="$(jq -r '.hash' <<< "$json")"
      update-source-version dolphin-emu "$version" --rev="$rev"
    '';
  };

  meta = with lib; {
    homepage = "https://dolphin-emu.org";
    description = "Gamecube/Wii/Triforce emulator for x86_64 and ARMv8";
    mainProgram = if stdenv.hostPlatform.isDarwin then "Dolphin" else "dolphin-emu";
    branch = "master";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      MP2E
      ashkitten
      xfix
      ivar
    ];
<<<<<<< HEAD
=======
    # Requires both LLVM and SDK bump
    broken = stdenv.isDarwin && stdenv.isx86_64;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
