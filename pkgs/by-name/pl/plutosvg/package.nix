{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "sammycage";
    repo = "plutosvg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4JLk4+O9Tf8CGxMP0aDN70ak/8teZH3GWBWlrIkPQm4=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # https://github.com/sammycage/plutosvg/pull/29
    ./0001-Emit-correct-pkg-config-file-if-paths-are-absolute.patch
    # https://github.com/sammycage/plutosvg/pull/31
    (fetchpatch {
      url = "https://github.com/sammycage/plutosvg/commit/17d60020e0b24299fae0e7df37637448b3b51488.patch";
      hash = "sha256-hY25ttsLQwvtQmDeOGSoCVDy34GUA0tNai/L3wpmPUo=";
    })
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
