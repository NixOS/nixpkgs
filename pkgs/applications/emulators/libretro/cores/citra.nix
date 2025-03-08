{
  lib,
  cmake,
  fetchFromGitHub,
  libGL,
  libGLU,
  libX11,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "citra";
  version = "0-unstable-2024-12-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "citra";
    rev = "a31aff7e1a3a66f525b9ea61633d2c5e5b0c8b31";
    hash = "sha256-HlhY4AeFQSabrmPQWLygjPGTWkIh0U0Hv1Fv4YFu9xg=";
    fetchSubmodules = true;
  };

  makefile = "Makefile";

  extraBuildInputs = [
    libGL
    libGLU
    libX11
  ];

  extraNativeBuildInputs = [ cmake ];

  # This changes `ir/opt` to `ir/var/empty` in `externals/dynarmic/src/dynarmic/CMakeLists.txt`
  # making the build fail, as that path does not exist
  dontFixCmake = true;

  # https://github.com/libretro/citra/blob/a31aff7e1a3a66f525b9ea61633d2c5e5b0c8b31/.gitlab-ci.yml#L6
  cmakeFlags = [
    (lib.cmakeBool "ENABLE_TESTS" false)
    (lib.cmakeBool "ENABLE_DEDICATED_ROOM" false)
    (lib.cmakeBool "ENABLE_SDL2" false)
    (lib.cmakeBool "ENABLE_QT" false)
    (lib.cmakeBool "ENABLE_WEB_SERVICE" false)
    (lib.cmakeBool "ENABLE_SCRIPTING" false)
    (lib.cmakeBool "ENABLE_OPENAL" false)
    (lib.cmakeBool "ENABLE_LIBUSB" false)
    (lib.cmakeBool "CITRA_ENABLE_BUNDLE_TARGET" false)
    (lib.cmakeBool "CITRA_WARNINGS_AS_ERRORS" false)
  ];

  meta = {
    description = "Port of Citra to libretro";
    homepage = "https://github.com/libretro/citra";
    license = lib.licenses.gpl2Plus;
  };
}
