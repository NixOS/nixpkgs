{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "yabause";
  version = "0-unstable-2025-12-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "yabause";
    rev = "65af22e96beb6d9b0b9a50a81a39c86a6d604c1c";
    hash = "sha256-LafC48f1m6pRWhXmfN+D+5r9qCNm1v9uLJVq5Wa5naE=";
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
