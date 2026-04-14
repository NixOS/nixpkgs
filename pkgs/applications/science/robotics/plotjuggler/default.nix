{
  lib,
  cmake,
  extra-cmake-modules,
  fetchFromGitHub,
  fetchurl,
  mkDerivation,
  mosquitto,
  protobuf,
  qtbase,
  qtsvg,
  qtwebsockets,
  qtx11extras,
  zeromq,
  zstd,
  lz4,
  lua5_4,
  fmt,
  nlohmann_json,
  stdenv,
  libglvnd,
  wrapQtAppsHook,
  libxcb,
  libxcb-util,
  libxcb-wm,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
}:

mkDerivation rec {
  pname = "plotjuggler";
  version = "3.16.0";

  src = fetchFromGitHub {
    owner = "facontidavide";
    repo = "PlotJuggler";
    rev = version;
    sha256 = "sha256-Bifhh/8C1ltvtpV/zRQabY4celNmHiD57hrCm8B8Bvg=";
  };

  # Fetch wasmer separately since it's a prebuilt binary
  wasmer = fetchurl {
    url = "https://github.com/wasmerio/wasmer/releases/download/v7.0.1/wasmer-linux-amd64.tar.gz";
    sha256 = "sha256-EKVYhbEetRsGuyT/GE+s3owqg8JSeCoMBOekaSZjDXI=";
  };

  # Fetch data_tamer since it's not packaged in nixpkgs
  dataTamer = fetchFromGitHub {
    owner = "PickNikRobotics";
    repo = "data_tamer";
    rev = "1.0.3";
    sha256 = "sha256-hGfoU6oK7vh39TRCBTYnlqEsvGLWCsLVRBXh3RDrmnY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    mosquitto
    protobuf
    qtbase
    qtsvg
    qtwebsockets
    qtx11extras
    zeromq
    zstd
    lz4
    lua5_4
    fmt
    nlohmann_json
  ]
  ++ lib.optionals stdenv.isLinux [
    # OpenGL support on Linux
    libglvnd
    # XCB libraries for drag and drop support
    libxcb
    libxcb-util
    libxcb-wm
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
    "-DCPM_USE_LOCAL_PACKAGES=ON"
    # Provide system dependencies
    "-DLua_FOUND=TRUE"
    "-DLUA_INCLUDE_DIR=${lua5_4}/include"
    "-DLUA_LIBRARIES=${lua5_4}/lib/liblua.so"
    "-Dfmt_FOUND=TRUE"
    "-Dfmt_DIR=${fmt}/lib/cmake/fmt"
    "-DNLOHMANN_JSON_INCLUDE_DIR=${nlohmann_json}/include"
  ];

  # Extract wasmer and setup data_tamer before building
  preConfigure = ''
    # Extract wasmer
    mkdir -p wasmer_dir
    tar -xzf ${wasmer} -C wasmer_dir
    export WASMER_DIR=$PWD/wasmer_dir

    # Setup data_tamer
    mkdir -p $NIX_BUILD_TOP/data_tamer
    cp -r ${dataTamer}/* $NIX_BUILD_TOP/data_tamer/
    chmod -R u+w $NIX_BUILD_TOP/data_tamer

    # Add WASMER_DIR to cmake flags (array syntax for structuredAttrs)
    cmakeFlags+=("-DWASMER_DIR=$WASMER_DIR")
  '';

  # Rewrite cmake files to use system libraries
  postPatch = ''
        # Rewrite lz4 cmake to use system library
        cat > cmake/find_or_download_lz4.cmake <<'CMAKEEOF'
    function(find_or_download_lz4)
      if(TARGET LZ4::lz4_static)
        message(STATUS "LZ4 targets already defined")
        return()
      endif()

      # Use system lz4
      find_library(LZ4_LIBRARY NAMES lz4 REQUIRED)
      find_path(LZ4_INCLUDE_DIR NAMES lz4.h REQUIRED)

      add_library(lz4_static UNKNOWN IMPORTED)
      set_target_properties(lz4_static PROPERTIES
        IMPORTED_LOCATION "''${LZ4_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "''${LZ4_INCLUDE_DIR}")

      add_library(LZ4::lz4_static ALIAS lz4_static)
      set(LZ4_FOUND TRUE CACHE BOOL "LZ4 found")
    endfunction()
    CMAKEEOF

        # Rewrite zstd cmake to use system library
        cat > cmake/find_or_download_zstd.cmake <<'CMAKEEOF'
    function(find_or_download_zstd)
      if(TARGET zstd::libzstd_static)
        message(STATUS "ZSTD targets already defined")
        return()
      endif()

      # Use system zstd
      find_library(ZSTD_LIBRARY NAMES zstd REQUIRED)
      find_path(ZSTD_INCLUDE_DIR NAMES zstd.h REQUIRED)

      add_library(libzstd_static UNKNOWN IMPORTED)
      set_target_properties(libzstd_static PROPERTIES
        IMPORTED_LOCATION "''${ZSTD_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "''${ZSTD_INCLUDE_DIR}")

      add_library(zstd::libzstd_static ALIAS libzstd_static)
      set(ZSTD_FOUND TRUE CACHE BOOL "ZSTD found")
    endfunction()
    CMAKEEOF

        # Rewrite data_tamer cmake to use our downloaded copy
        cat > cmake/find_or_download_data_tamer.cmake <<'CMAKEEOF'
    function(find_or_download_data_tamer)
      if(NOT TARGET data_tamer_parser AND NOT TARGET data_tamer::parser)
        add_library(data_tamer_parser INTERFACE)
        target_include_directories(
          data_tamer_parser
          INTERFACE "$ENV{NIX_BUILD_TOP}/data_tamer/data_tamer_cpp/include")
        add_library(data_tamer::parser ALIAS data_tamer_parser)
      endif()
    endfunction()
    CMAKEEOF

        # Rewrite wasmer cmake to use our downloaded copy
        cat > cmake/download_wasmer.cmake <<'CMAKEEOF'
    function(download_wasmer)
      if(TARGET wasmer::wasmer)
        return()
      endif()

      set(wasmer_SOURCE_DIR ''${WASMER_DIR})

      set(WASMER_STATIC_LIBRARY_NAME ''${CMAKE_STATIC_LIBRARY_PREFIX}wasmer''${CMAKE_STATIC_LIBRARY_SUFFIX})

      if(WIN32 AND NOT MINGW)
        add_library(wasmer::wasmer SHARED IMPORTED GLOBAL)
        set_target_properties(wasmer::wasmer PROPERTIES
            IMPORTED_IMPLIB   "''${wasmer_SOURCE_DIR}/lib/wasmer.dll.lib"
            IMPORTED_LOCATION "''${wasmer_SOURCE_DIR}/lib/wasmer.dll"
            INTERFACE_INCLUDE_DIRECTORIES "''${wasmer_SOURCE_DIR}/include"
            INTERFACE_LINK_LIBRARIES "ws2_32;advapi32;userenv;ntdll;bcrypt")
      else()
        if(NOT EXISTS "''${wasmer_SOURCE_DIR}/lib/''${WASMER_STATIC_LIBRARY_NAME}")
          message(FATAL_ERROR "wasmer library not found: ''${wasmer_SOURCE_DIR}/lib/''${WASMER_STATIC_LIBRARY_NAME}")
        endif()
        add_library(wasmer::wasmer UNKNOWN IMPORTED GLOBAL)
        set_target_properties(wasmer::wasmer PROPERTIES
            IMPORTED_LOCATION "''${wasmer_SOURCE_DIR}/lib/''${WASMER_STATIC_LIBRARY_NAME}"
            INTERFACE_INCLUDE_DIRECTORIES "''${wasmer_SOURCE_DIR}/include")
        if(WIN32)
          set_property(TARGET wasmer::wasmer APPEND PROPERTY
              INTERFACE_LINK_LIBRARIES "ws2_32;advapi32;userenv;ntdll;bcrypt")
          set_property(TARGET wasmer::wasmer APPEND PROPERTY
              INTERFACE_COMPILE_DEFINITIONS "WASM_API_EXTERN=;WASI_API_EXTERN=")
        else()
          set_property(TARGET wasmer::wasmer APPEND PROPERTY
              INTERFACE_LINK_LIBRARIES "pthread;dl;m")
        endif()
      endif()

      set(wasmer_FOUND TRUE CACHE BOOL "Whether wasmer was found or downloaded")
    endfunction()
    CMAKEEOF
  '';

  # Remove executable bit from libraries so they don't get wrapped in wrap-qt-apps-hook
  preFixup = ''
    chmod -x $out/bin/*.dylib $out/bin/*.so 2>/dev/null || true
  '';

  meta = with lib; {
    homepage = "https://www.plotjuggler.io/";
    description = "Fast, intuitive and extensible time series visualization tool.";
    license = licenses.mpl20;
    maintainers = with maintainers; [ toel ];
    platforms = platforms.unix;
  };
}
