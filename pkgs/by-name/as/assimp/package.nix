{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  zlib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "assimp";
  version = "6.0.2";
  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "assimp";
    repo = "assimp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ixtqK+3iiL17GEbEVHz5S6+gJDDQP7bVuSfRMJMGEOY=";
  };

  patches = [
    # Fix build with gcc15
    # https://github.com/assimp/assimp/pull/6283
    (fetchpatch {
      name = "assimp-fix-invalid-vector-gcc15.patch";
      url = "https://github.com/assimp/assimp/commit/59bc03d931270b6354690512d0c881eec8b97678.patch";
      hash = "sha256-O+JPwcOdyFtmFE7eZojHo1DUavF5EhLYlUyxtYo/KF4=";
    })
  ]
  ++ lib.optionals stdenv.hostPlatform.isMinGW [
    # Qt3D uses the system assimp and needs assimp's exported CMake package to
    # accept newer assimp versions (e.g. 6.x) when requesting an older major.
    # Matches MSYS2 mingw-w64-assimp.
    ./cmake-any-newer-version.patch

    # MinGW: make Assimp respect GNUInstallDirs (and therefore Nixpkgs' multi-output
    # install dirs) instead of its non-Unix fallback cache vars.
    ./mingw-use-gnuinstalldirs.patch

    # MinGW: prevent assimp_cmd's executable import library from clobbering
    # libassimp.dll.a when OUTPUT_NAME is `assimp`.
    ./mingw-assimp-cmd-unique-importlib.patch

    # Windows/MinGW: export ASSIMP_DLL to consumers when building shared libs so
    # downstreams compile with correct dllimport semantics.
    ./windows-export-assimp-dll.patch
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    zlib
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  cmakeFlags = [
    (lib.cmakeBool "ASSIMP_BUILD_ASSIMP_TOOLS" true)
    (lib.cmakeBool "ASSIMP_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ]
  ++ lib.optionals stdenv.hostPlatform.isMinGW [
    # MinGW: don't build/install the bundled zlib; use nixpkgs zlib instead.
    # Matches MSYS2 mingw-w64-assimp.
    (lib.cmakeBool "ASSIMP_BUILD_ZLIB" false)
    # Keep MinGW builds robust across compilers (MSYS2 disables Werror).
    (lib.cmakeBool "ASSIMP_WARNINGS_AS_ERRORS" false)
  ];

  # Some matrix tests fail on non-86_64-linux:
  # https://github.com/assimp/assimp/issues/6246
  # https://github.com/assimp/assimp/issues/6247
  # On Darwin, the bundled googletest is not compatible with Clang 21.
  #  contrib/googletest/googletest/include/gtest/gtest-printers.h:498:35:
  #  error: implicit conversion from 'char16_t' to 'char32_t' may change the meaning of the represented code unit
  #  [-Werror,-Wcharacter-conversion]
  doCheck = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64;
  checkPhase = ''
    runHook preCheck
    bin/unit
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/assimp/assimp/releases/tag/${finalAttrs.src.tag}";
    description = "Library to import various 3D model formats";
    mainProgram = "assimp";
    homepage = "https://www.assimp.org/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
