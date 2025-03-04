{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
  zlib,
  python3Packages,
  nix-update-script,
  fetchpatch2,
}:

let
  exploragram = fetchFromGitHub {
    owner = "BrunoLevy";
    repo = "exploragram";
    rev = "3190f685653f8aa75b7c4604d008c59a999f1bb6";
    hash = "sha256-9ePCOyQWSxu12PtHFSxfoDcvTtxvYR3T68sU3cAfZiE=";
  };
  testdata = fetchFromGitHub {
    owner = "BrunoLevy";
    repo = "geogram.data";
    rev = "ceab6179189d23713b902b6f26ea2ff36aea1515";
    hash = "sha256-zUmYI6+0IdDkglLzzWHS8ZKmc5O6aJ2X4IwRBouRIxI=";
  };
in
stdenv.mkDerivation rec {
  pname = "geogram";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "BrunoLevy";
    repo = "geogram";
    tag = "v${version}";
    hash = "sha256-v7ChuE9F/z1MD5OUMiGXZWiGqjMauIka4sNXVDe/yYU=";
    fetchSubmodules = true;
  };

  outputs = [
    "bin"
    "lib"
    "dev"
    "doc"
    "out"
  ];

  cmakeFlags = [
    # Triangle is unfree
    "-DGEOGRAM_WITH_TRIANGLE=OFF"

    # Disable some extra features (feel free to create a PR if you need one of those)

    # If GEOGRAM_WITH_LEGACY_NUMERICS is enabled GeoGram will build its own version of
    # ARPACK, CBLAS, CLAPACK, LIBF2C and SUPERLU
    "-DGEOGRAM_WITH_LEGACY_NUMERICS=OFF"

    # Don't build Lua
    "-DGEOGRAM_WITH_LUA=OFF"

    # Disable certain features requiring GLFW
    "-DGEOGRAM_WITH_GRAPHICS=OFF"

    # NOTE: Options introduced by patch (see below)
    "-DGEOGRAM_INSTALL_CMAKE_DIR=${placeholder "dev"}/lib/cmake"
    "-DGEOGRAM_INSTALL_PKGCONFIG_DIR=${placeholder "dev"}/lib/pkgconfig"
  ];

  nativeBuildInputs = [
    cmake
    doxygen
  ];

  buildInputs = [
    zlib
  ];

  # exploragram library is not listed as submodule and must be copied manually
  prePatch = ''
    cp -r ${exploragram} ./src/lib/exploragram/ && chmod 755 ./src/lib/exploragram/
  '';

  patches = [
    # This patch replaces the bundled (outdated) zlib with our zlib
    # Should be harmless, but if there are issues this patch can also be removed
    # Also check https://github.com/BrunoLevy/geogram/issues/49 for progress
    ./replace-bundled-zlib.patch

    # fixes https://github.com/BrunoLevy/geogram/issues/203, remove when 1.9.3 is released
    (fetchpatch2 {
      url = "https://github.com/BrunoLevy/geogram/commit/2e1b6fba499ddc55b2150a1f610cf9f8d4934c39.patch";
      hash = "sha256-t6Pocf3VT8HpKOSh1UKKa0QHpsZyFqlAng6ltiAfKA8=";
    })
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isAarch64 ''
    substituteInPlace cmake/platforms/*/config.cmake \
      --replace "-m64" ""
  '';

  postBuild = ''
    make doc-devkit-full
  '';

  nativeCheckInputs = [
    python3Packages.robotframework
  ];

  doCheck = true;

  checkPhase =
    let
      skippedTests = [
        # Skip slow RVD test
        "RVD"

        # Needs unfree library geogramplus with extended precision
        # see https://github.com/BrunoLevy/geogram/wiki/GeogramPlus
        "CSGplus"
      ];
    in
    ''
      runHook preCheck

      ln -s ${testdata} ../tests/data

      source tests/testenv.sh
      robot \
        ${lib.concatMapStringsSep " " (t: lib.escapeShellArg "--skip=${t}") skippedTests} \
        ../tests

      runHook postCheck
    '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Programming Library with Geometric Algorithms";
    longDescription = ''
      Geogram contains the main results in Geometry Processing from the former ALICE Inria project,
      that is, more than 30 research articles published in ACM SIGGRAPH, ACM Transactions on Graphics,
      Symposium on Geometry Processing and Eurographics.
    '';
    homepage = "https://github.com/BrunoLevy/geogram";
    license = licenses.bsd3;

    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with maintainers; [ tmarkus ];
  };
}
