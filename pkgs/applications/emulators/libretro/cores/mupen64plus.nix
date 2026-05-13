{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  libGL,
  libGLU,
  libpng,
  mkLibretroCore,
  nasm,
  libx11,
}:
mkLibretroCore {
  core = "mupen64plus-next";
  version = "0-unstable-2026-04-02";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mupen64plus-libretro-nx";
    rev = "58b9daf940fb43f09c3984c6a7c730f4b4c24861";
    hash = "sha256-9d1gbDDK2rOt/a9NNRQVJJmiE+UdohM/yPI5WstNmtA=";
  };

  # Fix for GCC 14
  # https://github.com/libretro/mupen64plus-libretro-nx/pull/526
  patches = [
    (fetchpatch2 {
      name = "minizip-avoid_trying_to_compile_problematic_code.patch";
      url = "https://github.com/libretro/mupen64plus-libretro-nx/commit/2b05477dd9cd99e7f9425f58cb544f454fc0d813.patch?full_index=1";
      hash = "sha256-Q0yymeS6taeFRt6BH6IX5q1SDUMh2Zn3mFpdJguyk9M=";
    })
    (fetchpatch2 {
      name = "EmuThread-align_with_co_create()_and_pthread_create().patch";
      url = "https://github.com/libretro/mupen64plus-libretro-nx/commit/26dfd670ffdd5ed6a03e6704dc73f82c13d81dd9.patch?full_index=1";
      hash = "sha256-BraCR/b8DTmVAWrUxiXp9nxBYvTpTW9OQAt8TP1eusI=";
    })
    (fetchpatch2 {
      name = "Fix_compilation_of_bundled_libzlib.patch";
      url = "https://github.com/libretro/mupen64plus-libretro-nx/commit/3c3e7fbc70b8f533c09c964cf468ba5e8d61351c.patch?full_index=1";
      hash = "sha256-PCJLNYhhccnWLcnPaHL6tz+5qdjogJRYfzZIh3r+Vlk=";
    })
  ];

  extraNativeBuildInputs = [
    nasm
  ];
  extraBuildInputs = [
    libGLU
    libGL
    libpng
    libx11
  ];
  makefile = "Makefile";
  makeFlags = [
    "HAVE_PARALLEL_RDP=1"
    "HAVE_PARALLEL_RSP=1"
    "HAVE_THR_AL=1"
    "LLE=1"
    "WITH_DYNAREC=${stdenv.hostPlatform.parsed.cpu.name}"
  ];

  meta = {
    description = "Libretro port of Mupen64 Plus";
    homepage = "https://github.com/libretro/mupen64plus-libretro-nx";
    license = lib.licenses.gpl3Only;
  };
}
