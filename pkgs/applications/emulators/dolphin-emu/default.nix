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
, minizip-ng
, openal
, pugixml
, qtbase
, qtsvg
, SDL2
, sfml
, udev
, vulkan-loader
, xxHash
, xz

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
  version = "5.0-21088";

  src = fetchFromGitHub {
    owner = "dolphin-emu";
    repo = "dolphin";
    rev = "9240f579eab18a2f67eef23846a6b508393d0e6c";
    hash = "sha256-lOiDbEQZoi9Bsiyta/w+B1VXNNW4qST2cBZekqo5dDA=";
    fetchSubmodules = true;
  };

  patches = [
    # Remove when merged https://github.com/dolphin-emu/dolphin/pull/12070
    ./find-minizip-ng.patch

    # fix buidl w/ glibc-2.39
    (fetchpatch {
      url = "https://github.com/dolphin-emu/dolphin/commit/3da2e15e6b95f02f66df461e87c8b896e450fdab.patch";
      hash = "sha256-+8yGF412wQUYbyEuYWd41pgOgEbhCaezexxcI5CNehc=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    stdenv.cc
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreBluetooth
    ForceFeedback
    IOBluetooth
    IOKit
    moltenvk
    OpenGL
    VideoToolbox
  ] ++ [
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
    minizip-ng
    openal
    pugixml
    qtbase
    qtsvg
    SDL2
    sfml
    xxHash
    xz # LibLZMA
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
  ];

  cmakeFlags = [
    "-DDISTRIBUTOR=NixOS"
    "-DDOLPHIN_WC_REVISION=${src.rev}"
    "-DDOLPHIN_WC_DESCRIBE=${version}"
    "-DDOLPHIN_WC_BRANCH=master"
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
      version = if stdenv.hostPlatform.isDarwin then "Dolphin 5.0" else version;
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
      ashkitten
      ivar
    ];
  };
}
