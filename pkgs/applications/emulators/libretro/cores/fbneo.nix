{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-02-08";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "e21e3f3c40eb4422b93b8984ef46fe04cdaee9db";
    hash = "sha256-7hZ2TJwHtgyHd+CZahazXZnKhfNpWZqfev9jtTHlmag=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
