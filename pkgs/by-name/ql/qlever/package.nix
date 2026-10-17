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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ad-freiburg";
    repo = "qlever";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T9EPRAt5WFaNJJi0WlX3mnLbn2WH/OGc6bs+Ig2liKk=";
    fetchSubmodules = true;
  };

  patches = [
    # TODO: remove on next release
    ./link-boost-url-against-index.patch
  ];

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

    # GCC 16 ICEs in `pass_late_warn_uninitialized` while pretty-printing the
    # offending expression of a `-Wmaybe-uninitialized` warning, e.g. for
    # `src/engine/IndexScan.cpp`. The reported warnings are false positives
    # coming from abseil and libstdc++ internals anyway.
    "-Wno-maybe-uninitialized"
  ];

  cmakeFlags = [
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
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_URIPARSER" "${uriparser}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_OPENTELEMETRY-CPP" "${opentelemetry-cpp}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_PROMETHEUS-CPP" "${opentelemetry-cpp}/third_party/prometheus-cpp")
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
        rev = "972a15cedd008d846f1a39b2e88ce48d7f166cbd";
        hash = "sha256-oEU+dz8ax1S36+f9OysjB0GnQj8mjZx1VsZ/UgckdDI=";
      };

      uriparser = fetchFromGitHub {
        owner = "uriparser";
        repo = "uriparser";
        rev = "04d8b8df5e0c6bf6c06e472540c015943a613bd2";
        hash = "sha256-k4hRy4kfsaxUNIITPNxzqVgl+AwiR1NpKcE9DtAbwxc=";
      };

      opentelemetry-cpp = fetchFromGitHub {
        owner = "open-telemetry";
        repo = "opentelemetry-cpp";
        rev = "2d80af1b1d26e300d9c0f7f51fa360f22c773523";
        hash = "sha256-rw7N1/pQiyOZZQBqQR6nysot7Z/2cXS4k8wlW1gzvV0=";
        fetchSubmodules = true;
      };

      googletest = fetchFromGitHub {
        owner = "google";
        repo = "googletest";
        rev = "973323ed64a05b128418e7eab67016db5ba049df";
        hash = "sha256-Z4W2zFRHYoTnWmhrAP4jodqpub0dec4YWgjBzhp1fgA=";
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
        rev = "0e2a41b61694e823df1b7d77174b139253c7ac39";
        hash = "sha256-afdekChP8rpJZuamDSWSdcrMWzCMmALXp6nyzhnE6kI=";
        postFetch = ''
          pushd $out
          patch -p1 -i ${./fix-range-v3-borrowed-range-instantiation.patch}
          popd
        '';
      };

      spatialjoin = fetchFromGitHub {
        owner = "ad-freiburg";
        repo = "spatialjoin";
        rev = "d1170ee08f0b932c73ca53af75338eacb3e043f6";
        hash = "sha256-+fSugNUX5iHk+WC5j7OGVyCZqhhX73AIek+wxOExlgE=";
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
        rev = "255c84dadd029fd8ad25c5efb5933e47beaa00c7";
        hash = "sha256-TJT2Kzc64zI42FAbbGWP3Sshh1dU/D/AtEpgZrrhebg=";
      };

      s2 = fetchFromGitHub {
        owner = "google";
        repo = "s2geometry";
        rev = "a37aba69f14af676e9605cd9515c8aca6cef8342";
        hash = "sha256-eMwSfQ+UfM0k6uMfd9NUYY/FioHKqGL0zY51cBnHaWM=";
      };
    };

    tests = nixosTests.qlever;

    updateScript = ./update.sh;
  };

  __structuredAttrs = true;

  meta = {
    description = "Graph database implementing the RDF and SPARQL standards";
    homepage = "https://github.com/ad-freiburg/qlever";
    changelog = "https://github.com/ad-freiburg/qlever/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "qlever";
    platforms = lib.platforms.all;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
