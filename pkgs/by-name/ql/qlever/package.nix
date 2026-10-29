{
  lib,
  stdenv,
  fetchFromGitHub,

  pkg-config,
  cmake,

  boost,
  bzip2,
  icu,
  openssl,
  zlib,
  zstd,
  jemalloc,

  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qlever";
  version = "0.5.47";

  src = fetchFromGitHub {
    owner = "ad-freiburg";
    repo = "qlever";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sRV3OZTg9Q2Nvys0OgMbBGRqWPm+8P9zJD9rcaEEZ/Y=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    bzip2
    icu
    jemalloc
    openssl
    zlib
    zstd
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # fixes error: inlining failed in call to 'always_inline' ... :
    # function body can be overwritten at link time
    "-fno-semantic-interposition"
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeFeature "LOGLEVEL" "INFO")
    (lib.cmakeBool "USE_PARALLEL" true)
    (lib.cmakeBool "_NO_TIMING_TESTS" true)
    (lib.cmakeBool "JEMALLOC_MANUALLY_INSTALLED" true)

    # disable fetching external dependencies
    (lib.cmakeBool "USE_CONAN" false)
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
  ]
  ++ (with finalAttrs.passthru.deps; [
    # map external dependencies to FetchContent names
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_FSST" "${fsst}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_RE2" "${re2}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GOOGLETEST" "${googletest}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_NLOHMANN-JSON" "${nlohmann-json}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ANTLR" "${antlr}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_RANGE-V3" "${range-v3}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SPATIALJOIN" "${spatialjoin}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CTRE" "${ctre}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ABSEIL" "${abseil}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_S2" "${s2}")
  ]);

  passthru = {
    deps = {
      fsst = fetchFromGitHub {
        owner = "cwida";
        repo = "fsst";
        rev = "b228af6356196095eaf9f8f5654b0635f969661e";
        hash = "sha256-XuE/nalt2HEYaII9NytUs0rCLGHOUFEclO+0h7pu4V0=";
      };

      re2 = fetchFromGitHub {
        owner = "google";
        repo = "re2";
        rev = "bc0faab533e2b27b85b8ad312abf061e33ed6b5d";
        hash = "sha256-cKXe8r5MUag/z+seem4Zg/gmqIQjaCY7DBxiKlrnXPs=";
      };

      googletest = fetchFromGitHub {
        owner = "google";
        repo = "googletest";
        rev = "7917641ff965959afae189afb5f052524395525c";
        hash = "sha256-Pfkx/hgtqryPz3wI0jpZwlRRco0s2FLcvUX1EgTGFIw=";
      };

      nlohmann-json = fetchFromGitHub {
        owner = "nlohmann";
        repo = "json";
        tag = "v3.12.0";
        hash = "sha256-cECvDOLxgX7Q9R3IE86Hj9JJUxraDQvhoyPDF03B2CY=";
      };

      antlr = fetchFromGitHub {
        owner = "antlr";
        repo = "antlr4";
        rev = "cc82115a4e7f53d71d9d905caa2c2dfa4da58899";
        hash = "sha256-DxxRL+FQFA+x0RudIXtLhewseU50aScHKSCDX7DE9bY=";
      };

      range-v3 = fetchFromGitHub {
        owner = "joka921";
        repo = "range-v3";
        rev = "42340ef354f7b4e4660268b788e37008d9cc85aa";
        hash = "sha256-/17XLLLuEkcqeklVtqlgtu19tNTT3bLRHrU1aOPLhTw=";
      };

      spatialjoin = fetchFromGitHub {
        owner = "ad-freiburg";
        repo = "spatialjoin";
        rev = "c358e479ebb5f40df99522e69a0b52d73416020b";
        hash = "sha256-/BQzyCx1KxnOeLLZkvqno2KN/VHAEu228zrsJaqYu/c=";
        fetchSubmodules = true;
      };

      ctre = fetchFromGitHub {
        owner = "hanickadot";
        repo = "compile-time-regular-expressions";
        rev = "e34c26ba149b9fd9c34aa0f678e39739641a0d1e";
        hash = "sha256-/44oZi6j8+a1D6ZGZpoy82GHjPtqzOvuS7d3SPbH7fs=";
      };

      abseil = fetchFromGitHub {
        owner = "abseil";
        repo = "abseil-cpp";
        rev = "93ac3a4f9ee7792af399cebd873ee99ce15aed08";
        hash = "sha256-a18+Yj9fvDigza4b2g38L96hge5feMwU6fgPmL/KVQU=";
      };

      s2 = fetchFromGitHub {
        owner = "google";
        repo = "s2geometry";
        rev = "5b5eccd54a08ae03b4467e79ffbb076d0b5f221e";
        hash = "sha256-VjgGcGgQlKmjUq+JU0JpyhOZ9pqwPcBUFEPGV9XoHc0=";
      };
    };

    tests = nixosTests.qlever;

    updateScript = ./update.sh;
  };

  __structuredAttrs = true;

  meta = {
    description = "Graph database implementing the RDF and SPARQL standards";
    homepage = "https://github.com/ad-freiburg/qlever";
    mainProgram = "qlever";
    platforms = lib.platforms.all;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
