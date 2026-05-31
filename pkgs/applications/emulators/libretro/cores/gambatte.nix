{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2026-05-29";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "589c29a07cd773315b6d5d350c3e050cbda7cd9d";
    hash = "sha256-DEivvVqWMh/G9aqub3TzOjwcLcpNyEQzH9EZ29y3NIM=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
