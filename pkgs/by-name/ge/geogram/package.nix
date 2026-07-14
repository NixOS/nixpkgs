{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
  zlib,
  nix-update-script,
  stb,
  libmeshb,
  rply,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "geogram";
  version = "1.9.9";

  src = fetchFromGitHub {
    owner = "BrunoLevy";
    repo = "geogram";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wAq6j/HUOv6In49lJVRZ2iS6ugbtYOxHN3PwTE1HZks=";
    fetchSubmodules = true;
  };

  outputs = [
    "lib"
    "dev"
    "doc"
    "out"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  cmakeFlags = [
    # Triangle is unfree
    (lib.cmakeBool "GEOGRAM_WITH_TRIANGLE" false)

    # Disable some extra features (feel free to create a PR if you need one of those)

    # If GEOGRAM_WITH_LEGACY_NUMERICS is enabled GeoGram will build its own version of
    # ARPACK, CBLAS, CLAPACK, LIBF2C and SUPERLU
    (lib.cmakeBool "GEOGRAM_WITH_LEGACY_NUMERICS" false)

    # Don't build Lua
    (lib.cmakeBool "GEOGRAM_WITH_LUA" false)

    # Disable certain features requiring GLFW
    (lib.cmakeBool "GEOGRAM_WITH_GRAPHICS" false)

    # Enables a packaging mode in some places
    (lib.cmakeBool "GEOGRAM_FOR_DEBIAN" true)

    # Only build the library itself
    (lib.cmakeBool "GEOGRAM_LIB_ONLY" true)

    # NOTE: Options introduced by patch (see below)
    (lib.cmakeOptionType "path" "GEOGRAM_INSTALL_CMAKE_DIR" "${placeholder "dev"}/lib/cmake")
    (lib.cmakeOptionType "path" "GEOGRAM_INSTALL_PKGCONFIG_DIR" "${placeholder "dev"}/lib/pkgconfig")
  ];

  nativeBuildInputs = [
    cmake
    doxygen
  ];

  buildInputs = [
    zlib
    stb
    libmeshb
    rply
  ];

  patches = [
    # This patch replaces the bundled (outdated) zlib with our zlib
    # Should be harmless, but if there are issues this patch can also be removed
    # Also check https://github.com/BrunoLevy/geogram/issues/49 for progress
    ./replace-bundled-zlib.patch

    ./cmake-fix-link-libraries.patch
  ];

  postBuild = ''
    make doc-devkit-full
  '';

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Programming Library with Geometric Algorithms";
    longDescription = ''
      Geogram contains the main results in Geometry Processing from the former ALICE Inria project,
      that is, more than 30 research articles published in ACM SIGGRAPH, ACM Transactions on Graphics,
      Symposium on Geometry Processing and Eurographics.
    '';
    homepage = "https://github.com/BrunoLevy/geogram";
    license = lib.licenses.bsd3;

    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ tmarkus ];
  };
})
