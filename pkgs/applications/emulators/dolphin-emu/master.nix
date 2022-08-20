{ lib, stdenv, fetchFromGitHub, pkg-config, cmake
, wrapQtAppsHook, qtbase, bluez, ffmpeg, libao, libGLU, libGL, pcre, gettext
, libXrandr, libusb1, libpthreadstubs, libXext, libXxf86vm, libXinerama
, libSM, libXdmcp, readline, openal, udev, libevdev, portaudio, curl, alsa-lib
, miniupnpc, enet, mbedtls, soundtouch, sfml, xz, writeScript
, vulkan-loader ? null, libpulseaudio ? null

# - Inputs used for Darwin
, CoreBluetooth, ForceFeedback, IOKit, OpenGL, libpng, hidapi }:

stdenv.mkDerivation rec {
  pname = "dolphin-emu";
  version = "5.0-16793";

  src = fetchFromGitHub {
    owner = "dolphin-emu";
    repo = "dolphin";
    rev = "3cd82b619388d0877436390093a6edc2319a6904";
    sha256 = "sha256-0k+kmq/jkCy52wGcmvtwmnLxUfxk3k0mvsr5wfX8p30=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ]
  ++ lib.optional stdenv.isLinux wrapQtAppsHook;

  buildInputs = [
    curl ffmpeg libao libGLU libGL pcre gettext libpthreadstubs libpulseaudio
    libXrandr libXext libXxf86vm libXinerama libSM readline openal libXdmcp
    portaudio libusb1 libpng hidapi miniupnpc enet mbedtls soundtouch sfml xz
    qtbase
  ] ++ lib.optionals stdenv.isLinux [
    bluez udev libevdev alsa-lib vulkan-loader
  ] ++ lib.optionals stdenv.isDarwin [
    CoreBluetooth OpenGL ForceFeedback IOKit
  ];

  cmakeFlags = [
    "-DUSE_SHARED_ENET=ON"
    "-DENABLE_LTO=ON"
    "-DDOLPHIN_WC_REVISION=${src.rev}"
    "-DDOLPHIN_WC_DESCRIBE=${version}"
    "-DDOLPHIN_WC_BRANCH=master"
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
    sed -i -e 's,DISTRIBUTOR "None",DISTRIBUTOR "NixOS",g' CMakeLists.txt
  '' + lib.optionalString stdenv.isDarwin ''
    sed -i -e 's,if(NOT APPLE),if(true),g' CMakeLists.txt
    sed -i -e 's,if(LIBUSB_FOUND AND NOT APPLE),if(LIBUSB_FOUND),g' \
      CMakeLists.txt
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -D $src/Data/51-usb-device.rules $out/etc/udev/rules.d/51-usb-device.rules
  '';


  passthru.updateScript = writeScript "dolphin-update-script" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    set -eou pipefail
    json="$(curl -s https://dolphin-emu.org/update/latest/beta)"
    version="$(jq -r '.shortrev' <<< "$json")"
    rev="$(jq -r '.hash' <<< "$json")"
    update-source-version dolphin-emu-beta "$version" --rev="$rev"
  '';

  meta = with lib; {
    homepage = "https://dolphin-emu.org";
    description = "Gamecube/Wii/Triforce emulator for x86_64 and ARMv8";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ MP2E ashkitten xfix ];
    branch = "master";
    broken = stdenv.isDarwin;
    platforms = platforms.unix;
  };
}
