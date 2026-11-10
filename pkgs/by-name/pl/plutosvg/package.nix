{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  validatePkgConfig,
  testers,
  cmake,
  ninja,
  plutovg,
  enableFreetype ? false,
  freetype,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "plutosvg";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "sammycage";
    repo = "plutosvg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+Fo1B9jH/jjcSkrW5Hm6giIYm7zYh7puFFhC6er7XIM=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # https://github.com/sammycage/plutosvg/pull/29
    ./0001-Emit-correct-pkg-config-file-if-paths-are-absolute.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    validatePkgConfig
  ];

  propagatedBuildInputs = [
    plutovg
  ]
  ++ lib.optional enableFreetype freetype;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "PLUTOSVG_ENABLE_FREETYPE" enableFreetype)
  ];

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    cmake-config = testers.hasCmakeConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "plutosvg" ];
      versionCheck = true;
    };
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/sammycage/plutosvg";
    changelog = "https://github.com/sammycage/plutosvg/releases/tag/${finalAttrs.src.tag}";
    description = "Tiny SVG rendering library in C";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcin-serwin ];
    pkgConfigModules = [ "plutosvg" ];
  };
})
