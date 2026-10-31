{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "earcut-hpp";
  version = "0-unstable-2026-10-31";

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "earcut.hpp";
    rev = "2fbafada15dbe5350c606426e17111b91a964e55";
    hash = "sha256-DbYRO/7ICq5Tk5eKj4WTYD3mq2GxvgXkhfbkIhExzWA=";
  };

  # Test fixture data/JSON (not a C++ library) fetched by CMakeLists.txt via
  # FetchContent when EARCUT_BUILD_TESTS is on. Pinned here and handed back in
  # via FETCHCONTENT_SOURCE_DIR_* below so the sandboxed build never touches
  # the network.
  earcutJsSrc = fetchFromGitHub {
    owner = "mapbox";
    repo = "earcut";
    tag = "v3.2.4";
    hash = "sha256-aS3RWSfGpeikdvrj7pl3BgS4yKEcqbEixlgPl+0LJCk=";
  };

  picojsonSrc = fetchFromGitHub {
    owner = "kazuho";
    repo = "picojson";
    tag = "v1.3.0";
    hash = "sha256-wMYfVuDEBCrU0cl32suCiM9yaayvy1zRkrqVMMLSntY=";
  };

  googletestSrc = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    tag = "v1.15.2";
    hash = "sha256-1OJ2SeSscRBNr7zZ/a8bJGIqAnhkg45re0j3DtPfcXM=";
  };

  cmakeFlags = [
    (lib.cmakeBool "EARCUT_BUILD_TESTS" true)
    # Not correctness tests, and VIZ needs a GUI/OpenGL context, inappropriate
    # for a sandboxed build.
    (lib.cmakeBool "EARCUT_BUILD_BENCH" false)
    (lib.cmakeBool "EARCUT_BUILD_VIZ" false)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_EARCUT_JS" "${finalAttrs.earcutJsSrc}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_PICOJSON" "${finalAttrs.picojsonSrc}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GOOGLETEST" "${finalAttrs.googletestSrc}")
    # Without these, googletest's own install() rules run too and leak
    # gtest/gmock headers, static libs, and .pc files into $out.
    (lib.cmakeBool "BUILD_GMOCK" false)
    (lib.cmakeBool "INSTALL_GTEST" false)
  ];

  doCheck = true;
  # ctest otherwise only reports the one earcut_tests target it wraps the
  # whole GTest binary as; -V surfaces that binary's own per-case output.
  checkFlags = [ "ARGS=-V" ];

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Fast, header-only polygon triangulation library";
    homepage = "https://github.com/mapbox/earcut.hpp";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
