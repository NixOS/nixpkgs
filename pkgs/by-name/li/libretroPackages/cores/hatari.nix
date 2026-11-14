{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "hatari";
  version = "0-unstable-2026-11-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "hatari";
    rev = "819c2f7fb2e3aaea5ce6a7db99836af3a985fcbd";
    hash = "sha256-ncPdxJHn9wpRWDwWFEhv6fA5mKIWMlHE15toInOYc0g=";
  };

  extraNativeBuildInputs = [ cmake ];

  # https://github.com/libretro/hatari/blob/819c2f7fb2e3aaea5ce6a7db99836af3a985fcbd/.gitlab-ci-libretro.yml#L10
  # without ENABLE_STATIC_ZLIB and ENABLE_STATIC_CAPSIMAGE, which would fetch
  # sources at configure time; zlib comes from mkLibretroCore
  cmakeFlags = [
    (lib.cmakeBool "ENABLE_LIBRETRO" true)
    (lib.cmakeBool "ENABLE_HATARI" false)
    (lib.cmakeBool "ENABLE_TOOLS" false)
  ];

  # src/CMakeLists.txt only links libm into the standalone Hatari binary,
  # leaving the core with unresolved math symbols
  env.NIX_LDFLAGS = "-lm";

  makefile = "Makefile";

  postBuild = "cd src";

  meta = {
    description = "Port of Hatari to libretro";
    homepage = "https://github.com/libretro/hatari";
    license = lib.licenses.gpl2Plus;
  };
}
