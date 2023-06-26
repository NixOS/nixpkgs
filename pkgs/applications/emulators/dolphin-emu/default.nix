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
, fmt_8
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
, mbedtls_2
, mgba
, miniupnpc
, minizip-ng
, openal
, pugixml
, qtbase
, sfml
, soundtouch
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
  version = "5.0-19368";

  src = fetchFromGitHub {
    owner = "dolphin-emu";
    repo = "dolphin";
    rev = "dadbeb4bae7e7fa23af2b46e0add4143094dc107";
    sha256 = "sha256-XLtFn2liONPizvrKyySZx0mY7qC2fpwhAWaRZLlEzh8=";
    fetchSubmodules = true;
  };

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
    fmt_8
    hidapi
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
    libGL
    libXext
    libXrandr
    # FIXME: Remove comment on next mgba version
    #mgba # Derivation doesn't support Darwin
    udev
    vulkan-loader
  ];

  cmakeFlags = [
    "-DDISTRIBUTOR=NixOS"
    "-DUSE_SHARED_ENET=ON"
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
  };
}
