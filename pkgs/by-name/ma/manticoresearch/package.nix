{
<<<<<<< HEAD
  bison,
  boost,
  callPackage,
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
  columnar = callPackage ./columnar.nix { };
=======
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  cmake,
  flex,
  pkg-config,
  boost,
  icu,
  libstemmer,
  mariadb-connector-c,
  re2,
  nlohmann_json,
  testers,
  manticoresearch,
}:

let
  columnar = stdenv.mkDerivation (finalAttrs: {
    pname = "columnar";
    version = "c21-s10"; # see NEED_COLUMNAR_API/NEED_SECONDARY_API in Manticore's cmake/GetColumnar.cmake
    src = fetchFromGitHub {
      owner = "manticoresoftware";
      repo = "columnar";
      rev = finalAttrs.version;
      hash = "sha256-TGFGFfoyHnPSr2U/9dpqFLUN3Dt2jDQrTF/xxDY4pdE=";
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  cctz = stdenv.mkDerivation {
    pname = "manticore-cctz";
    version = "0-unstable-2024-05-08";

    src = fetchFromGitHub {
      owner = "manticoresoftware";
      repo = "cctz";
      rev = "cf11f758e2532161c9e21c3ec2461b0fafb15853";
      hash = "sha256-oXn6YowOg+9jaXXSX1fggkgE9o9xZ4hlmrpdpEHot68=";
    };

    patches = [ ./cctz-cmake-policy.patch ];

    nativeBuildInputs = [ cmake ];
    cmakeBuildDir = "build_dir"; # Avoid conflicts with the pre-existing `BUILD` file on case-insensitive FS

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
  version = "15.1.0";
=======
in
stdenv.mkDerivation (finalAttrs: {
  pname = "manticoresearch";
  version = "6.2.12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "manticoresoftware";
    repo = "manticoresearch";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-ESiM2D11o1QnctDzL7WQ+usad7nvs0YSPOpZzSfYv4Y=";
=======
    hash = "sha256-UD/r7rlJ5mR3wg4doKT/nTwTWzlulngUjOPNEjmykB8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    bison
    cmake
    flex
    pkg-config
  ];

  buildInputs = [
    boost
<<<<<<< HEAD
    cctz
    columnar.dev
    croaring
=======
    columnar
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    icu.dev
    libstemmer
    mariadb-connector-c
    nlohmann_json
    uni-algo
    re2
<<<<<<< HEAD
    xxhash
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  postPatch = ''
    sed -i 's/set ( Boost_USE_STATIC_LIBS ON )/set ( Boost_USE_STATIC_LIBS OFF )/' src/CMakeLists.txt

<<<<<<< HEAD
    # Skip jieba, it requires a bunch of additional dependencies
    sed -i '/with_get ( jieba /d' CMakeLists.txt

    # Fill in a version number for the VERNUMBERS macro
    sed -i 's/0\.0\.0/${finalAttrs.version}/' src/sphinxversion.h.in
=======
    # supply our own packages rather than letting manticore download dependencies during build
    sed -i 's/^with_get/with_menu/' CMakeLists.txt
    sed -i 's/get_dep \( nlohmann_json .* \)/find_package(nlohmann_json)/' CMakeLists.txt
    sed -i 's/get_dep \( uni-algo .* \)/find_package(uni-algo)/' CMakeLists.txt
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  cmakeFlags = [
    "-DWITH_GALERA=0"
<<<<<<< HEAD
    "-DWITH_ICU=1"
    # Supply our own packages rather than letting manticore download dependencies during build
    "-DWITH_ICU_FORCE_STATIC=OFF"
    "-DWITH_RE2_FORCE_STATIC=OFF"
    "-DWITH_STEMMER_FORCE_STATIC=OFF"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    "-DWITH_MYSQL=1"
    "-DMYSQL_INCLUDE_DIR=${mariadb-connector-c.dev}/include/mariadb"
    "-DMYSQL_LIB=${mariadb-connector-c.out}/lib/mariadb/libmysqlclient.a"
    "-DCONFDIR=${placeholder "out"}/etc"
    "-DLOGDIR=/var/lib/manticoresearch/log"
    "-DRUNDIR=/var/run/manticoresearch"
<<<<<<< HEAD
    "-DDISTR=nixpkgs"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  postFixup = ''
    mkdir -p $out/lib/systemd/system
    cp ${finalAttrs.src}/dist/deb/manticore.service.in $out/lib/systemd/system/manticore.service
    substituteInPlace $out/lib/systemd/system/manticore.service \
<<<<<<< HEAD
      --replace-fail "@CMAKE_INSTALL_FULL_RUNSTATEDIR@" "/var/lib/manticore" \
      --replace-fail "@CMAKE_INSTALL_FULL_BINDIR@" "$out/bin" \
      --replace-fail "@CMAKE_INSTALL_FULL_SYSCONFDIR@" "$out/etc"

    mkdir $out/share/manticore/modules
    cp ${columnar}/share/manticore/modules/* $out/share/manticore/modules
=======
      --replace "@CMAKE_INSTALL_FULL_RUNSTATEDIR@" "/var/lib/manticore" \
      --replace "@CMAKE_INSTALL_FULL_BINDIR@" "$out/bin" \
      --replace "@CMAKE_INSTALL_FULL_SYSCONFDIR@" "$out/etc"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  passthru.tests.version = testers.testVersion {
    inherit (finalAttrs) version;
    package = manticoresearch;
    command = "searchd --version";
  };

<<<<<<< HEAD
  meta = {
    description = "Easy to use open source fast database for search";
    homepage = "https://manticoresearch.com";
    changelog = "https://github.com/manticoresoftware/manticoresearch/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "searchd";
    maintainers = [ lib.maintainers.jdelStrother ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Easy to use open source fast database for search";
    homepage = "https://manticoresearch.com";
    changelog = "https://github.com/manticoresoftware/manticoresearch/releases/tag/${finalAttrs.version}";
    license = licenses.gpl2;
    mainProgram = "searchd";
    maintainers = [ maintainers.jdelStrother ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
