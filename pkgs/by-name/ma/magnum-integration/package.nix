{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  magnum,
  magnum-plugins,
  magnum-extras,
  corrade,
  bullet,
  dartsim,
  eigen,
  glm,
  imgui,
  yoga,
  # builds and tests
  withImguiIntegration ? true,
  withBulletIntegration ? false,
  withDartIntegration ? false,
  withEigenIntegration ? true,
  withGlmIntegration ? false,
  # FIXME
  withYogaIntegration ? true,
}:

let
  magnumWithPlugins = magnum.withPlugins (
    [
      (magnum-plugins.override {
        withAssimpImporter = withDartIntegration; # needed for tests
      })
    ]
    ++ lib.optional withYogaIntegration magnum-extras
  );

in

stdenv.mkDerivation (_finalAttrs: {
  pname = "magnum-integration";
  version = "2020.06-unstable-2026-10-07";

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
  ++ lib.optional withDartIntegration dartsim
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

  meta = {
    description = "Integration libraries for the Magnum C++11 graphics engine";
    homepage = "https://github.com/mosra/magnum-integration";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.arntanguy ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
