{
  cmake,
  fetchFromGitHub,
  fetchzip,
  lib,
  pkg-config,
  replaceVars,
  simde,
  stdenv,
}:

let
  # Manticore fetches columnar from a tag that indicates the versions of libraries that columnar includes.
  # (See NEED_COLUMNAR_API/NEED_SECONDARY_API/NEED_KNN_API in Manticore's cmake/GetColumnar.cmake)
  # So this tag indicates columnar v27, secondary v18, and knn v9.
  libraryVersion = "c27-s18-k9";
  # If you inspect the revision that tag points to, there's also hopefully a more normal version tag too
  numericVersion = "9.0.0";
  columnarSource = fetchFromGitHub {
    owner = "manticoresoftware";
    repo = "columnar";
    tag = libraryVersion;
    hash = "sha256-26zSdLNJkC7zYHT8sDq/2mZPRfdc9db1vIIrkaiPqFM=";
  };
  hnswlib = stdenv.mkDerivation (finalAttrs: {
    pname = "hnswlib";
    version = "d7bb3bbd59220f62203012b2f649aa537cc97cdc"; # see HNSW_GITHUB in columnar's cmake/GetHNSW.cmake
    src = fetchFromGitHub {
      owner = "manticoresoftware";
      repo = "hnswlib";
      rev = "d7bb3bbd59220f62203012b2f649aa537cc97cdc";
      hash = "sha256-SDYf8J4auzqGBHqFMDFR6TVyNthCA4q6J4glcIssAJU=";
    };
    nativeBuildInputs = [
      cmake
      pkg-config
    ];
    meta = {
      description = "Header-only C++/python library for fast approximate nearest neighbors";
      homepage = "https://github.com/nmslib/hnswlib";
      license = lib.licenses.asl20;
      platforms = lib.platforms.all;
    };
  });
  pgm-index = stdenv.mkDerivation (finalAttrs: {
    pname = "pgm-index";
    version = "pgm_2022_08_02"; # see PGM_GITHUB in columnar's cmake/GetPGM.cmake
    src = fetchFromGitHub {
      owner = "manticoresoftware";
      repo = "PGM-index";
      rev = "5a5a763c7c07e56f56fd33137dcee9f1b3c3b640";
      hash = "sha256-p8CjY9r1TEi91HBac9rZ39Yae2XuNh2yQWbo65n90jU=";
    };
    nativeBuildInputs = [
      cmake
      pkg-config
    ];
    # Use the custom CMakeLists.txt from columnar
    postPatch = ''
      cp ${columnarSource}/pgm/CMakeLists.txt CMakeLists.txt
    '';
    meta = {
      description = "Piecewise Geometric Model index - a fast and space-efficient data structure";
      homepage = "https://github.com/gvinciguerra/PGM-index";
      license = lib.licenses.asl20;
      platforms = lib.platforms.all;
    };
  });
  streamvbyte = stdenv.mkDerivation (finalAttrs: rec {
    pname = "streamvbyte";
    version = "efdd9dace81a4a8f844267631879b500c6d913cf"; # see SVB_GITHUB in columnar's cmake/GetStreamvbyte.cmake
    src = fetchFromGitHub {
      owner = "manticoresoftware";
      repo = "streamvbyte";
      rev = version;
      hash = "sha256-a9E1aWBY/P7wI+kgHqhEiD3THctFfeFcy658RcNpHfQ=";
    };
    nativeBuildInputs = [
      cmake
      pkg-config
    ];
    # Enable SSE4.1 on x86_64 to avoid GCC 14 target attribute issues
    env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isx86_64 "-msse4.1";
    # Use the custom CMakeLists.txt from columnar
    postPatch = ''
      cp ${columnarSource}/streamvbyte/CMakeLists.txt CMakeLists.txt
    '';
    meta = {
      description = "Fast integer compression library using StreamVByte encoding";
      homepage = "https://github.com/manticoresoftware/streamvbyte/";
      license = lib.licenses.asl20;
      platforms = lib.platforms.all;
    };
  });
  fastpfor = stdenv.mkDerivation (finalAttrs: {
    pname = "fastpfor";
    version = "simde"; # see FP_GITHUB in columnar's cmake/GetFastPFor.cmake
    src = fetchFromGitHub {
      owner = "manticoresoftware";
      repo = "FastPFor";
      rev = "5f6b7df8f0dba402bb616a81ca510bfeb04c42ce";
      hash = "sha256-O9nqgsZKT+q9dHdh2RahF1U8KXCmDp0ld7hNvVREM8k=";
    };
    nativeBuildInputs = [
      cmake
      pkg-config
    ];
    buildInputs = [ simde ];
    # Enable SSE3/SSSE3/SSE4.1 on x86_64 to avoid GCC 14 target attribute issues
    # (Columnar's custom libfastpfor/CMakeLists.txt comments these out. I think get away with it because they just build with clang?)
    env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isx86_64 "-msse3 -mssse3 -msse4.1";

    # Columnar uses its own version of CMakeLists.txt to compile libfastpfor
    prePatch = ''
      cp ${columnarSource}/libfastpfor/CMakeLists.txt CMakeLists.txt
    '';
    patches = [ ./fastpfor-cmake-policy.patch ];
    postPatch = ''
      # Use nixpkgs simde rather than FetchContent-ing from github
      sed -i '/Add simde for arm/,/FetchContent_GetProperties ( simde )/c\
        message(STATUS "Using nixpkgs simde for arm")\n\
        set(simde_SOURCE_DIR "${simde.src}")\n\
        set(simde_POPULATED 1)\n\
      ' CMakeLists.txt
    '';
    meta = {
      description = "Fast integer compression";
      homepage = "https://github.com/manticoresoftware/FastPFor/";
      license = lib.licenses.asl20;
      platforms = lib.platforms.all;
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "manticore-columnar";
  version = numericVersion;

  outputs = [
    "out"
    "dev"
  ];

  src = columnarSource;
  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    fastpfor
    hnswlib
    pgm-index
    streamvbyte
  ];

  patches = [
    (replaceVars ./columnar.patch {
      version = numericVersion;
    })
  ];
  cmakeFlags = [
    "-DSKIP_KNN=ON" # Skip KNN & embeddings for now
  ];
  postPatch = ''
    # I've failed to get avx compiled, skip it for now.
    sed -i '/set (ADD_AVX_BUILDS 1)/d' CMakeLists.txt
  '';

  meta = {
    description = "Manticore Columnar Library - columnar storage and secondary indexes library for Manticore Search";
    homepage = "https://github.com/manticoresoftware/columnar";
    license = lib.licenses.asl20;
  };
})
