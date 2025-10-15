{
  bison,
  boost,
  cmake,
  croaring,
  fetchFromGitHub,
  flex,
  icu,
  lib,
  libstemmer,
  manticoresearch,
  mariadb-connector-c,
  nlohmann_json,
  pkg-config,
  re2,
  stdenv,
  testers,
}:

let
  columnar = stdenv.mkDerivation (finalAttrs: {
    pname = "columnar";
    version = "c26-s18-k9"; # see NEED_COLUMNAR_API/NEED_SECONDARY_API/NEED_KNN_API in Manticore's cmake/GetColumnar.cmake
    src = fetchFromGitHub {
      owner = "manticoresoftware";
      repo = "columnar";
      rev = finalAttrs.version;
      hash = "sha256-DnqixxvUltajZBBs/kFHjIr6dFpYkgrKVoQJe3Rtfag=";
    };
    nativeBuildInputs = [ cmake ];
    cmakeFlags = [ "-DAPI_ONLY=ON" ];
    meta = {
      description = "Column-oriented storage and secondary indexing library";
      homepage = "https://github.com/manticoresoftware/columnar/";
      license = lib.licenses.asl20;
      platforms = lib.platforms.all;
    };
  });
  uni-algo = stdenv.mkDerivation (finalAttrs: {
    pname = "uni-algo";
    version = "0.7.2";
    src = fetchFromGitHub {
      owner = "manticoresoftware";
      repo = "uni-algo";
      rev = "v${finalAttrs.version}";
      hash = "sha256-+V9w4UJ+3KsyZUYht6OEzms60mBHd8FewVc7f21Z9ww=";
    };
    nativeBuildInputs = [ cmake ];
    meta = {
      description = "Unicode Algorithms Implementation for C/C++";
      homepage = "https://github.com/manticoresoftware/uni-algo";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
    };
  });
  cctz = stdenv.mkDerivation {
    pname = "manticore-cctz";
    version = "0-unstable-2024-05-08";

    src = fetchFromGitHub {
      owner = "manticoresoftware";
      repo = "cctz";
      rev = "cf11f758e2532161c9e21c3ec2461b0fafb15853";
      hash = "sha256-oXn6YowOg+9jaXXSX1fggkgE9o9xZ4hlmrpdpEHot68=";
    };
    nativeBuildInputs = [ cmake ];
    cmakeBuildDir = "build_dir"; # Avoid conflicts with the pre-existing `BUILD` file on case-insensitive FS
    cmakeFlags = [
      # Fix the build with CMake 4.
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    ];

    meta = {
      description = "Library for translating between absolute and civil times using the rules of a time zone";
      homepage = "https://github.com/manticoresoftware/cctz";
      license = lib.licenses.asl20;
      platforms = lib.platforms.all;
    };
  };
  xxhash = stdenv.mkDerivation {
    pname = "manticore-xxhash";
    version = "0.8.2-unstable-2024-07-24";

    src = fetchFromGitHub {
      owner = "manticoresoftware";
      repo = "xxHash";
      rev = "72997b0070a031c063f86a308aec77ae742706d3";
      hash = "sha256-QAIxZeMiohm/BYyO0f70En6GOv7t3yLH2pJfkUek7Js=";
    };
    nativeBuildInputs = [ cmake ];
    meta = {
      description = "Extremely fast non-cryptographic hash algorithm";
      homepage = "https://github.com/manticoresoftware/xxhash";
      license = with lib.licenses; [
        bsd2
        gpl2
      ];
      platforms = lib.platforms.all;
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "manticoresearch";
  version = "13.13.4";

  src = fetchFromGitHub {
    owner = "manticoresoftware";
    repo = "manticoresearch";
    tag = finalAttrs.version;
    hash = "sha256-FMkjrqTa1yj0sCIdsaoaJqJZBKswtLQbRV/jvnW7i0o=";
  };

  nativeBuildInputs = [
    bison
    cmake
    flex
    pkg-config
  ];

  buildInputs = [
    boost
    cctz
    columnar
    croaring
    icu.dev
    libstemmer
    mariadb-connector-c
    nlohmann_json
    uni-algo
    re2
    xxhash
  ];

  postPatch = ''
    sed -i 's/set ( Boost_USE_STATIC_LIBS ON )/set ( Boost_USE_STATIC_LIBS OFF )/' src/CMakeLists.txt

    # Skip jieba, it requires a bunch of additional dependencies
    sed -i '/with_get ( jieba /d' CMakeLists.txt

    # Fill in a version number for the VERNUMBERS macro
    sed -i 's/0\.0\.0/${finalAttrs.version}/' src/sphinxversion.h.in
  '';

  cmakeFlags = [
    "-DWITH_GALERA=0"
    "-DWITH_ICU=1"
    # Supply our own packages rather than letting manticore download dependencies during build
    "-DWITH_ICU_FORCE_STATIC=OFF"
    "-DWITH_RE2_FORCE_STATIC=OFF"
    "-DWITH_STEMMER_FORCE_STATIC=OFF"
    "-DWITH_MYSQL=1"
    "-DMYSQL_INCLUDE_DIR=${mariadb-connector-c.dev}/include/mariadb"
    "-DMYSQL_LIB=${mariadb-connector-c.out}/lib/mariadb/libmysqlclient.a"
    "-DCONFDIR=${placeholder "out"}/etc"
    "-DLOGDIR=/var/lib/manticoresearch/log"
    "-DRUNDIR=/var/run/manticoresearch"
    "-DDISTR=nixpkgs"
  ];

  postFixup = ''
    mkdir -p $out/lib/systemd/system
    cp ${finalAttrs.src}/dist/deb/manticore.service.in $out/lib/systemd/system/manticore.service
    substituteInPlace $out/lib/systemd/system/manticore.service \
      --replace-fail "@CMAKE_INSTALL_FULL_RUNSTATEDIR@" "/var/lib/manticore" \
      --replace-fail "@CMAKE_INSTALL_FULL_BINDIR@" "$out/bin" \
      --replace-fail "@CMAKE_INSTALL_FULL_SYSCONFDIR@" "$out/etc"
  '';

  passthru.tests.version = testers.testVersion {
    inherit (finalAttrs) version;
    package = manticoresearch;
    command = "searchd --version";
  };

  meta = with lib; {
    description = "Easy to use open source fast database for search";
    homepage = "https://manticoresearch.com";
    changelog = "https://github.com/manticoresoftware/manticoresearch/releases/tag/${finalAttrs.version}";
    license = licenses.gpl3;
    mainProgram = "searchd";
    maintainers = [ maintainers.jdelStrother ];
    platforms = platforms.all;
  };
})
