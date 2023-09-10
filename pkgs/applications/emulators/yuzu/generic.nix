{ version
, src
, branch
, compat-list

, lib
, stdenv
, wrapQtAppsHook
, alsa-lib
, boost
, catch2_3
, cmake
, cpp-jwt
, cubeb
, discord-rpc
, doxygen
, enet
, fetchurl
, ffmpeg
, fmt
, glslang
, httplib
, inih
, libjack2
, libopus
, libpulseaudio
, libusb1
, libva
, libzip
, lz4
, nlohmann_json
, perl
, pkg-config
, python3
, qtbase
, qtmultimedia
, qttools
, qtwayland
, qtwebengine
, rapidjson
, SDL2
, sndio
, speexdsp
, udev
, vulkan-headers
, vulkan-loader
, zlib
, zstd
}:

let
  tzinfoVersion = "220816";
  tzinfo = fetchurl {
    url = "https://github.com/lat9nq/tzdb_to_nx/releases/download/${tzinfoVersion}/${tzinfoVersion}.zip";
    hash = "sha256-yv8ykEYPu9upeXovei0u16iqQ7NasH6873KnQy4+KwI=";
  };
in stdenv.mkDerivation {
  pname = "yuzu-${branch}";

  inherit version src;

  nativeBuildInputs = [
    cmake
    doxygen
    perl
    pkg-config
    python3
    wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    boost
    catch2_3
    cpp-jwt
    cubeb
    discord-rpc
    # intentionally omitted: dynarmic - prefer vendored version for compatibility
    enet
    ffmpeg
    fmt
    glslang
    httplib
    inih
    libjack2
    libopus
    libpulseaudio
    libusb1
    libva
    libzip
    # intentionally omitted: LLVM - heavy, only used for stack traces in the debugger
    lz4
    nlohmann_json
    qtbase
    qtmultimedia
    qttools
    qtwayland
    qtwebengine
    rapidjson
    SDL2
    sndio
    speexdsp
    udev
    vulkan-headers
    # intentionally omitted: xbyak - prefer vendored version for compatibility
    zlib
    zstd
  ];

  # This changes `ir/opt` to `ir/var/empty` in `externals/dynarmic/src/dynarmic/CMakeLists.txt`
  # making the build fail, as that path does not exist
  dontFixCmake = true;

  cmakeFlags = [
    # actually has a noticeable performance impact
    "-DYUZU_ENABLE_LTO=ON"

    # build with qt6
    "-DENABLE_QT6=ON"
    "-DENABLE_QT_TRANSLATION=ON"

    # use system libraries
    "-DYUZU_USE_EXTERNAL_SDL2=OFF"
    "-DYUZU_USE_EXTERNAL_VULKAN_HEADERS=OFF"

    # don't check for missing submodules
    "-DYUZU_CHECK_SUBMODULES=OFF"

    # enable some optional features
    "-DYUZU_USE_QT_WEB_ENGINE=ON"
    "-DYUZU_USE_QT_MULTIMEDIA=ON"
    "-DUSE_DISCORD_PRESENCE=ON"

    # We dont want to bother upstream with potentially outdated compat reports
    "-DYUZU_ENABLE_COMPATIBILITY_REPORTING=OFF"
    "-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF" # We provide this deterministically
  ];

  # Fixes vulkan detection.
  # FIXME: patchelf --add-rpath corrupts the binary for some reason, investigate
  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib"
  ];

  preConfigure = ''
    # see https://github.com/NixOS/nixpkgs/issues/114044, setting this through cmakeFlags does not work.
    cmakeFlagsArray+=(
      "-DTITLE_BAR_FORMAT_IDLE=yuzu | ${branch} ${version} (nixpkgs) {}"
      "-DTITLE_BAR_FORMAT_RUNNING=yuzu | ${branch} ${version} (nixpkgs) | {}"
    )

    # provide pre-downloaded tz data
    mkdir -p build/externals/nx_tzdb
    ln -sf ${tzinfo} build/externals/nx_tzdb/${tzinfoVersion}.zip
  '';

  # This must be done after cmake finishes as it overwrites the file
  postConfigure = ''
    ln -sf ${compat-list} ./dist/compatibility_list/compatibility_list.json
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://yuzu-emu.org";
    changelog = "https://yuzu-emu.org/entry";
    description = "The ${branch} branch of an experimental Nintendo Switch emulator written in C++";
    longDescription = ''
      An experimental Nintendo Switch emulator written in C++.
      Using the mainline branch is recommended for general usage.
      Using the early-access branch is recommended if you would like to try out experimental features, with a cost of stability.
    '';
    mainProgram = "yuzu";
    platforms = [ "x86_64-linux" ];
    license = with licenses; [
      gpl3Plus
      # Icons
      asl20 mit cc0
    ];
    maintainers = with maintainers; [
      ashley
      ivar
      joshuafern
      sbruder
      k900
    ];
  };
}
