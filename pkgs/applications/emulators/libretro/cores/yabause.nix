{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "yabause";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "yabause";
    rev = "7cb15b8f9eea5a6fa7cae34468a6989522bcba75";
    hash = "sha256-UWZgt0vdjncM7JCzdSWa4XZMJBJ/pnk4QpSKz459Fq0=";
  };

  makefile = "Makefile";
  # Disable SSE for non-x86. DYNAREC doesn't build on aarch64.
  makeFlags = lib.optional (!stdenv.hostPlatform.isx86) "HAVE_SSE=0";
  preBuild = "cd yabause/src/libretro";

  meta = {
    description = "Port of Yabause to libretro";
    homepage = "https://github.com/libretro/yabause";
    license = lib.licenses.gpl2Only;
  };
}
