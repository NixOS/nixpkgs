{
  stdenv,
  lib,
  testers,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  cjson,
  cmocka,
  mbedtls,
  lz4,

  # for passthru.tests
  ffmpeg-headless,
  obs-studio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "librist";
  version = "0.2.20";

  __structuredAttrs = true;
  strictDeps = true;
  separateDebugInfo = true;

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "rist";
    repo = "librist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TaO1vQsJ/sJ/YFW7Ykv9HywsrtEy/3R4+BfxS1v/ZBY=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  # glibc 2.43 C23 const-preserving strchr/strstr macros
  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=discarded-qualifiers";
  };

  mesonFlags = lib.mapAttrsToList lib.mesonBool {
    test = finalAttrs.finalPackage.doCheck;
    fallback_builtin = false;
  };

  buildInputs = [
    cjson
    mbedtls
    lz4
  ];

  checkInputs = [ cmocka ];
  # needs disabledTest support
  doCheck = false;

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    inherit ffmpeg-headless obs-studio;
  };

  meta = {
    description = "Library that can be used to easily add the RIST protocol to your application";
    homepage = "https://code.videolan.org/rist/librist";
    license = with lib.licenses; [
      bsd2
      mit
      isc
    ];
    maintainers = with lib.maintainers; [ raphaelr ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "librist" ];
  };
})
