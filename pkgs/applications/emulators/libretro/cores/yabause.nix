{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "yabause";
  version = "0-unstable-2026-04-10";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "yabause";
    rev = "76faf7c601359bafc41785325d686644000a7ba9";
    hash = "sha256-UHmUsqAK+As6qfvhto2aOsW9A/lZMypfn2NxFui2x8c=";
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
