{ pname
, version
, src
, branch
, compat-list

, lib
, stdenv
, runCommandLocal
, substituteAll
, wrapQtAppsHook
, alsa-lib
, boost
, catch2
, cmake
, doxygen
, ffmpeg
, fmt_8
, glslang
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
, qttools
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

stdenv.mkDerivation rec {
  inherit pname version src;

  # Replace icons licensed under CC BY-ND 3.0 with free ones to allow
  # for binary redistribution: https://github.com/yuzu-emu/yuzu/pull/8104
  # The patch hosted on GitHub has the binary information stripped, so
  # it has been regenerated with "git format-patch --text --full-index --binary"
  patches = [ ./yuzu-free-icons.patch ];

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
    catch2
    ffmpeg
    fmt_8
    glslang
    libjack2
    libopus
    libpulseaudio
    libusb1
    libva
    libzip
    lz4
    nlohmann_json
    qtbase
    qttools
    qtwebengine
    rapidjson
    SDL2
    sndio
    speexdsp
    udev
    zlib
    zstd
  ];

  doCheck = true;

  # This changes `ir/opt` to `ir/var/empty` in `externals/dynarmic/src/dynarmic/CMakeLists.txt`
  # making the build fail, as that path does not exist
  dontFixCmake = true;

  cmakeFlags = [
    "-DYUZU_USE_BUNDLED_QT=OFF"
    "-DYUZU_USE_BUNDLED_FFMPEG=OFF"
    "-DYUZU_USE_BUNDLED_OPUS=OFF"
    "-DYUZU_USE_EXTERNAL_SDL2=OFF"

    "-DENABLE_QT_TRANSLATION=ON"
    "-DYUZU_USE_QT_WEB_ENGINE=ON"
    "-DUSE_DISCORD_PRESENCE=ON"

    # We dont want to bother upstream with potentially outdated compat reports
    "-DYUZU_ENABLE_COMPATIBILITY_REPORTING=OFF"
    "-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF" # We provide this deterministically
  ];

  preConfigure = ''
    # This prevents a check for submodule directories.
    rm -f .gitmodules

    # see https://github.com/NixOS/nixpkgs/issues/114044, setting this through cmakeFlags does not work.
    cmakeFlagsArray+=(
      "-DTITLE_BAR_FORMAT_IDLE=yuzu ${branch} ${version}"
      "-DTITLE_BAR_FORMAT_RUNNING=yuzu ${branch} ${version} | {3}"
    )
  '';

  # This must be done after cmake finishes as it overwrites the file
  postConfigure = ''
    ln -sf ${compat-list} ./dist/compatibility_list/compatibility_list.json
  '';

  # Fix vulkan detection
  postFixup = ''
    for bin in $out/bin/yuzu $out/bin/yuzu-cmd; do
      wrapProgram $bin --prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib
    done
  '';

  passthru.updateScript = runCommandLocal "yuzu-${branch}-updateScript" {
    script = substituteAll {
      src = ./update.sh;
      inherit branch;
    };
  } "install -Dm755 $script $out";

  meta = with lib; {
    homepage = "https://yuzu-emu.org";
    changelog = "https://yuzu-emu.org/entry";
    description = "The ${branch} branch of an experimental Nintendo Switch emulator written in C++";
    longDescription = ''
      An experimental Nintendo Switch emulator written in C++.
      Using the mainline branch is recommanded for general usage.
      Using the early-access branch is recommanded if you would like to try out experimental features, with a cost of stability.
    '';
    mainProgram = "yuzu";
    platforms = [ "x86_64-linux" ];
    license = with licenses; [
      gpl3Plus
      # Icons. Note that this would be cc0 and cc-by-nd-30 without the "yuzu-free-icons" patch
      asl20 mit cc0
    ];
    maintainers = with maintainers; [
      ashley
      ivar
      joshuafern
      sbruder
    ];
  };
}
