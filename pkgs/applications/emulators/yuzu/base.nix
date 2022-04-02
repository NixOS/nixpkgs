{ pname, version, src, branchName
, stdenv, lib, wrapQtAppsHook
, cmake, pkg-config
, libpulseaudio, libjack2, alsa-lib, sndio
, vulkan-loader, vulkan-headers
, qtbase, qtwebengine, qttools
, nlohmann_json, rapidjson
, zlib, zstd, libzip, lz4
, glslang
, boost173
, catch2
, fmt_8
, SDL2
, udev
, libusb1
, ffmpeg
}:

stdenv.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];
  buildInputs = [
    libpulseaudio libjack2 alsa-lib sndio
    vulkan-loader vulkan-headers
    qtbase qtwebengine qttools
    nlohmann_json rapidjson
    zlib zstd libzip lz4
    glslang
    boost173
    catch2
    fmt_8
    SDL2
    udev
    libusb1
    ffmpeg
  ];

  cmakeFlags = [
    "-DYUZU_USE_BUNDLED_QT=OFF"
    "-DYUZU_USE_BUNDLED_SDL2=OFF"
    "-DYUZU_USE_BUNDLED_FFMPEG=OFF"
    "-DENABLE_QT_TRANSLATION=ON"
    "-DYUZU_USE_QT_WEB_ENGINE=ON"
    "-DUSE_DISCORD_PRESENCE=ON"
  ];

  # This changes `ir/opt` to `ir/var/empty` in `externals/dynarmic/src/dynarmic/CMakeLists.txt`
  # making the build fail, as that path does not exist
  dontFixCmake = true;

  preConfigure = ''
    # Trick the configure system. This prevents a check for submodule directories.
    rm -f .gitmodules

    # see https://github.com/NixOS/nixpkgs/issues/114044, setting this through cmakeFlags does not work.
    cmakeFlagsArray+=(
      "-DTITLE_BAR_FORMAT_IDLE=yuzu ${branchName} ${version}"
      "-DTITLE_BAR_FORMAT_RUNNING=yuzu ${branchName} ${version} | {3}"
    )
  '';

  # Fix vulkan detection
  postFixup = ''
    wrapProgram $out/bin/yuzu --prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib
    wrapProgram $out/bin/yuzu-cmd --prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib
  '';

  meta = with lib; {
    homepage = "https://yuzu-emu.org";
    description = "The ${branchName} branch of an experimental Nintendo Switch emulator written in C++";
    longDescription = ''
      An experimental Nintendo Switch emulator written in C++.
      Using the mainline branch is recommanded for general usage.
      Using the early-access branch is recommanded if you would like to try out experimental features, with a cost of stability.
    '';
    license = with licenses; [
      gpl2Plus
      # Icons
      cc-by-nd-30 cc0
    ];
    maintainers = with maintainers; [ ivar joshuafern sbruder ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64; # Currently aarch64 is not supported.
  };
}
