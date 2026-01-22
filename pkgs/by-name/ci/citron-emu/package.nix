{
  lib,
  stdenv,
  boost,
  catch2_3,
  cmake,
  cubeb,
  glslang,
  libopus,
  libusb1,
  libva,
  lz4,
  nlohmann_json,
  pkg-config,
  SDL2,
  qt6,
  zlib,
  zstd,
  ninja,
  wrapGAppsHook3,
  enet,
  ffmpeg,
  fmt,
  openal,
  rapidjson,
  openssl,
  speexdsp,
  vulkan-headers,
  vulkan-loader,
  vulkan-utility-libraries,
  gamemode,
  unzip,
  fetchFromGitea,
  fetchurl,
}:
let
  version = "0.12.25";
  src = fetchFromGitea {
    fetchSubmodules = true;
    domain = "git.citron-emu.org";
    owner = "Citron";
    repo = "Emulator";
    tag = "0.12.25";
    sha256 = "sha256-Su+SvCb6KDF9/ilb6Y/RZTOq/ffaMTWiJZy8nmGZ3n4=";
  };
  # Dependency, fetches the timezone data.
  # Source states posix envoriment is required to compile
  # By defauld the CMake file trys to download this url
  nx-tzdb = fetchurl {
    url = "https://github.com/lat9nq/tzdb_to_nx/releases/download/221202/221202.zip";
    hash = "sha256-mRzW+iIwrU1zsxHmf+0RArU8BShAoEMvCz+McXFFK3c=";
  };
  inherit (qt6)
    qtbase
    qtmultimedia
    qttools
    qtwayland
    qtwebengine
    wrapQtAppsHook
    ;
in
stdenv.mkDerivation rec {
  pname = "citron-emu";
  inherit version src nx-tzdb;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wrapGAppsHook3
    wrapQtAppsHook
    glslang
    qttools
    unzip
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    qtwayland
    qtwebengine
    SDL2
    boost
    enet
    ffmpeg
    fmt
    libopus
    libusb1
    libva
    lz4
    nlohmann_json
    openal
    rapidjson
    openssl
    speexdsp
    vulkan-headers
    vulkan-loader
    vulkan-utility-libraries
    zlib
    zstd
    catch2_3
    cubeb
    gamemode
  ];

  dontFixCmake = true;

  cmakeFlags = [
    "-GNinja"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DCITRON_USE_BUNDLED_VCPKG=OFF"
    "-DCITRON_USE_BUNDLED_QT=OFF"
    "-DCITRON_USE_BUNDLED_FFMPEG=OFF"
    "-DCITRON_USE_BUNDLED_SDL2=OFF"
    "-DCITRON_USE_EXTERNAL_SDL2=OFF"
    "-DCITRON_USE_EXTERNAL_VULKAN_HEADERS=OFF"
    "-DCITRON_USE_EXTERNAL_VULKAN_UTILITY_LIBRARIES=OFF"
    "-DCITRON_TESTS=OFF"
    "-DCITRON_CHECK_SUBMODULES=OFF"
    "-DCITRON_USE_QT_MULTIMEDIA=ON"
    "-DCITRON_USE_QT_WEB_ENGINE=ON"
    "-DCITRON_DOWNLOAD_TIME_ZONE_DATA=OFF"
    "-DENABLE_QT6=ON"
    "-DENABLE_QT_TRANSLATION=ON"
    "-DUSE_DISCORD_PRESENCE=ON"
    "-DCITRON_USE_FASTER_LD=OFF"
    "-DCMAKE_C_FLAGS=-march=x86-64-v3"
    "-DCMAKE_CXX_FLAGS=-march=x86-64-v3"
    "-DCITRON_ENABLE_LTO=ON"
    "-DCITRON_TESTS=OFF"
    "-DTITLE_BAR_FORMAT_RUNNING=citron | ${version} {}"
    "-DTITLE_BAR_FORMAT_IDLE=citron | ${version}"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isx86_64 "-msse4.1";

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}"
  ];

  preConfigure = ''
    mkdir -p build/externals/nx_tzdb
    unzip ${nx-tzdb} -d build/externals/nx_tzdb/nx_tzdb
  '';

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstall = ''
    # Install udev rules for input devices
    install -Dm644 $src/dist/72-citron-input.rules $out/lib/udev/rules.d/72-citron-input.rules
  '';

  meta = with lib; {
    homepage = "https://citron-emu.org";
    changelog = "https://git.citron-emu.org/";
    description = "Nintendo Switch emulator for PC";
    mainProgram = "citron";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ samemrecebi ];
  };
}
