{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  magnum,
  magnum-plugins,
  corrade,
  bullet ? null,
  dartsim ? null,
  eigen ? null,
  glm ? null,
  imgui ? null,
  yoga ? null,
  # builds and tests
  withImguiIntegration ? true,
  withBulletIntegration ? false,
  withDartIntegration ? false,
  withEigenIntegration ? true,
  withGlmIntegration ? false,
  # FIXME
  withYogaIntegration ? false, # needs magnum-extras, not packaged yet
}:

let
  magnumWithPlugins = magnum.withPlugins [
    (magnum-plugins.override {
      withAssimpImporter = withDartIntegration; # needed for tests
    })
  ];

  # Override dartsim to build with C++17 to avoid C++20 deprecation errors
  # TODO: remove when https://github.com/NixOS/nixpkgs/pull/581945 lands
  dartsimC17 = dartsim.overrideAttrs (old: {
    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
      "-DCMAKE_CXX_STANDARD=17"
      "-DCMAKE_CXX_STANDARD_REQUIRED=ON"
    ];
  });
in

stdenv.mkDerivation (_finalAttrs: {
  pname = "magnum-integration";
  version = "0.0.0";

  __structuredAttrs = true;
  strictDeps = true;
  doCheck = true;

  src = fetchFromGitHub {
    owner = "mosra";
    repo = "magnum-integration";
    rev = "e3d2b01b2067b514c04cb5d426da6941d0f09b1e";
    hash = "sha256-VBbA2hPVbg6E/28qEfuO3nnJcUCfDuRSyUzjZJazjKc=";
  };

  nativeBuildInputs = [
    cmake
    corrade
  ];
  propagatedBuildInputs = [
    magnumWithPlugins
  ]
  ++ lib.optional withBulletIntegration bullet
  ++ lib.optional withDartIntegration dartsimC17
  ++ lib.optional withEigenIntegration eigen
  ++ lib.optional withGlmIntegration glm
  ++ lib.optional withImguiIntegration imgui
  ++ lib.optional withYogaIntegration yoga;

  cmakeFlags = [
    (lib.cmakeBool "MAGNUM_BUILD_TESTS" true)
    (lib.cmakeBool "MAGNUM_WITH_BULLETINTEGRATION" withBulletIntegration)
    (lib.cmakeBool "MAGNUM_WITH_DARTINTEGRATION" withDartIntegration)
    (lib.cmakeBool "MAGNUM_WITH_EIGENINTEGRATION" withEigenIntegration)
    (lib.cmakeBool "MAGNUM_WITH_GLMINTEGRATION" withGlmIntegration)
    (lib.cmakeBool "MAGNUM_WITH_IMGUIINTEGRATION" withImguiIntegration)
    (lib.cmakeBool "MAGNUM_WITH_YOGAINTEGRATION" withYogaIntegration)
  ]
  ++ lib.optional withDartIntegration "-DCMAKE_CXX_VERSION=17";

  patches = lib.optional withImguiIntegration ./imgui_disable_tests.patch;

  meta = with lib; {
    description = "Integration libraries for the Magnum C++11 graphics engine";
    homepage = "https://github.com/mosra/magnum-integration";
    license = licenses.bsd2;
    maintainers = with maintainers; [ arntanguy ];
    platforms = platforms.all;
  };
})
