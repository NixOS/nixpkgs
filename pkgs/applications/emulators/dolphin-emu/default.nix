{ lib
, stdenv
, fetchFromGitHub
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
  version = "5.0-21460";

  src = fetchFromGitHub {
    owner = "dolphin-emu";
    repo = "dolphin";
    rev = "a9544510468740b77cf06ef28daaa65fe247fd32";
    hash = "sha256-mhD7Uaqi8GzHdR7Y81TspvCnrZH2evWuWFgXMQ2c8g0=";
    fetchSubmodules = true;
  };

  patches = [
    # TODO: Remove when merged https://github.com/dolphin-emu/dolphin/pull/12736
    ./find-minizip-ng.patch
  ];

  strictDeps = true;

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
    minizip-ng
    openal
    pugixml
    qtbase
    qtsvg
    SDL2
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
      --replace-fail "if(NOT APPLE)" "if(true)" \
      --replace-fail "if(LIBUSB_FOUND AND NOT APPLE)" "if(LIBUSB_FOUND)"
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
