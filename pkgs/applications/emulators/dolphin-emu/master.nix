{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, wrapQtAppsHook
, qtbase
, bluez
, ffmpeg
, libGL
, libXrandr
, libusb1
, libXdmcp
, libXext
, openal
, udev
, libevdev
, cubeb
, curl
, alsa-lib
, miniupnpc
, enet
, mbedtls_2
, soundtouch
, sfml
, xz
, hidapi
, fmt_8
, vulkan-loader
, libpulseaudio
, bzip2
, libiconv
, pugixml
, xxHash

  # Used in passthru
, testers
, dolphin-emu-beta
, writeShellScript
, common-updater-scripts
, jq

  # Darwin-only dependencies
, CoreBluetooth
, ForceFeedback
, IOKit
, VideoToolbox
, OpenGL
, libpng
, moltenvk
}:

stdenv.mkDerivation rec {
  pname = "dolphin-emu";
  version = "5.0-17269";

  src = fetchFromGitHub {
    owner = "dolphin-emu";
    repo = "dolphin";
    rev = "48c9c224cf9f82f0f9f2690b7cc6283d7448480c";
    sha256 = "sha256-WC3jukRygZigLx987CzRmOmJ7DeS1atXrMzU98sRzEg=";
    fetchSubmodules = true;
  };

  patches = [
    # On x86_64-darwin CMake reportedly does not work without this in some cases.
    # See https://github.com/NixOS/nixpkgs/pull/190373#issuecomment-1241310765
    ./minizip-external-missing-include.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    cubeb
    curl
    ffmpeg
    pugixml
    xxHash
    libGL
    libpulseaudio
    openal
    libusb1
    libiconv
    libpng
    libXdmcp
    hidapi
    miniupnpc
    enet
    mbedtls_2
    soundtouch
    sfml
    xz
    qtbase
    fmt_8
    bzip2
  ] ++ lib.optionals stdenv.isLinux [
    libXrandr
    libXext
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
    VideoToolbox
    moltenvk
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
    # Bundles the application folder into a standalone executable, so we cannot devendor libraries
    "-DSKIP_POSTPROCESS_BUNDLE=ON"
    # Needs xcode so compilation fails with it enabled. We would want the version to be fixed anyways.
    # Note: The updater isn't available on linux, so we dont need to disable it there.
    "-DENABLE_AUTOUPDATE=OFF"
  ];

  qtWrapperArgs = lib.optionals stdenv.isLinux [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [vulkan-loader]}"
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
      package = dolphin-emu-beta;
      command = "dolphin-emu-nogui --version";
    };

    updateScript = writeShellScript "dolphin-update-script" ''
      set -eou pipefail
      export PATH=${lib.makeBinPath [ curl jq common-updater-scripts ]}

      json="$(curl -s https://dolphin-emu.org/update/latest/beta)"
      version="$(jq -r '.shortrev' <<< "$json")"
      rev="$(jq -r '.hash' <<< "$json")"
      update-source-version dolphin-emu-beta "$version" --rev="$rev"
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
