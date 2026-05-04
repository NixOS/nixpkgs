{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  libusbp,
  nlohmann_json,
  cli11,
  curl,
  libcpr,
  pkg-config,
  bossa,
}:
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "diypresso-client";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "diyPresso";
    repo = "diyPresso-Client";
    rev = "95d5fb11b0b9d4db91d53f771e84e3245293e988";
    hash = "sha256-OWCcR+k8QRzwx0V6k0ccZnq6Ci+5Rx8N4WRCirN2KSA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libusbp
    libusbp.dev
    nlohmann_json
    cli11
    curl
    libcpr
    libcpr.dev
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  postPatch = ''
    substituteInPlace src/DpcFirmware.cpp \
      --replace-fail '" -U true"' '" -U"'

    mkdir -p cmake/modules
    cat > cmake/modules/Findlibusbp.cmake << 'EOF'
include(FindPkgConfig)
if(PKG_CONFIG_FOUND)
  pkg_check_modules(LIBUSBP libusbp-1)
endif()

if(LIBUSBP_FOUND AND NOT TARGET libusbp::libusbp)
  add_library(libusbp::libusbp INTERFACE IMPORTED)
  set_target_properties(libusbp::libusbp PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "''${LIBUSBP_INCLUDE_DIRS}"
    INTERFACE_LINK_LIBRARIES "''${LIBUSBP_LINK_LIBRARIES}"
    INTERFACE_COMPILE_OPTIONS "''${LIBUSBP_CFLAGS_OTHER}"
  )
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(libusbp DEFAULT_MSG LIBUSBP_FOUND)
set(LIBUSBP_FOUND ''${LIBUSBP_FOUND} CACHE BOOL "libusbp found")
EOF

    cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(diyPressoClientCpp VERSION 0.1.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(BUILD_SHARED_LIBS ON)

list(INSERT CMAKE_MODULE_PATH 0 "''${CMAKE_SOURCE_DIR}/cmake/modules")

set(SOURCES
    src/main.cpp
    src/DpcSerial.cpp
    src/DpcDevice.cpp
    src/DpcSettings.cpp
    src/DpcFirmware.cpp
    src/DpcColors.cpp
    src/DpcDownload.cpp
)

find_package(CLI11 CONFIG REQUIRED)
find_package(nlohmann_json CONFIG REQUIRED)
find_package(cpr CONFIG REQUIRED)
find_package(libusbp REQUIRED)

if(TARGET libusbp::libusbp)
    set(LIBUSBP_TARGET libusbp::libusbp)
elseif(LIBUSBP_FOUND)
    set(LIBUSBP_TARGET ''${LIBUSBP_LIBRARIES})
else()
    message(FATAL_ERROR "No suitable libusbp target found")
endif()

add_executable(diypresso ''${SOURCES})

target_link_libraries(diypresso PRIVATE
    CLI11::CLI11
    nlohmann_json::nlohmann_json
    ''${LIBUSBP_TARGET}
    cpr::cpr
)

if(NOT MSVC)
    target_compile_options(diypresso PRIVATE -Wall -Wextra)
endif()

install(TARGETS diypresso DESTINATION bin)
EOF
  '';

  postInstall = ''
    ln -s ${bossa}/bin/bossac $out/bin/bossac
  '';

  meta = with lib; {
    description = "Management client for diyPresso espresso machines";
    homepage = "https://github.com/diyPresso/diyPresso-Client";
    license = licenses.gpl3Only;
    mainProgram = "diypresso";
    platforms = platforms.linux ++ platforms.darwin;
  };
})
