{
  lib,
  stdenv,

  fetchFromGitHub,
  fetchpatch,

  # propagatedNativeBuildInputs
  cmake,
  qt6Packages,

  # propagatedBuildInputs
  boost,
  cxxopts,
  eigen,
  glew,
  gtest,
  libGL,
  metis,
  tinyxml-2,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sofa";
  version = "24.12.00";

  src = fetchFromGitHub {
    owner = "sofa-framework";
    repo = "sofa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LeFIM1RJjA2ynimjE8XngOQ8gR7BgqqTZBbDp0KXxs0=";
  };

  patches = [
    # Include missing header for setw / setfill.
    # ref. https://github.com/sofa-framework/sofa/pull/5279
    # This was merged upstream and can be removed in next version
    (fetchpatch {
      url = "https://github.com/sofa-framework/sofa/commit/700b6cdd94fe24a51b2a7014fb0fc83e6abe1fbc.patch";
      hash = "sha256-czc1u03USQt18d7cMPmXYguBhSb5JOJLplPvoixp+3w=";
    })
    (fetchpatch {
      # Compat with metis > 5.1
      name = "sofamatrix-allow-newer-metis-versions.patch";
      url = "https://github.com/sofa-framework/sofa/commit/f1a45da7c77776ea9559b1958576b0187a8b9958.patch";
      hash = "sha256-YPMBKG1Ju5XON14CmSYNqljpqEbFRvI5SgKwOnxs7+I=";
    })
  ];

  propagatedNativeBuildInputs = [
    cmake
    qt6Packages.wrapQtAppsHook
  ];
  propagatedBuildInputs = [
    boost
    cxxopts
    eigen
    glew
    gtest
    qt6Packages.libqglviewer
    qt6Packages.qtbase
    libGL
    metis
    tinyxml-2
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "SOFA_ALLOW_FETCH_DEPENDENCIES" false)
  ];

  doCheck = true;

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -change \
      $out/lib/libSceneChecking.${finalAttrs.version}.dylib \
      $out/plugins/SceneChecking/lib/libSceneChecking.${finalAttrs.version}.dylib \
      $out/bin/.runSofa-${finalAttrs.version}-wrapped
  '';

  meta = {
    description = "Real-time multi-physics simulation with an emphasis on medical simulation";
    homepage = "https://github.com/sofa-framework/sofa/";
    changelog = "https://github.com/sofa-framework/sofa/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "runSofa";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
