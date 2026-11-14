{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "theodore";
  version = "0-unstable-2026-08-17";

  src = fetchFromGitHub {
    owner = "Zlika";
    repo = "theodore";
    rev = "4d469ce0f71ee046ceb78cdbf8e9f18364aaa918";
    hash = "sha256-5QSbU35DrjwyJnVG5Fsy8VXTJiXuHU3iOmyD8/yzQX8=";
    fetchSubmodules = true;
  };

  makefile = "Makefile";

  meta = {
    description = "Thomson MO/TO emulator core for libretro";
    homepage = "https://github.com/Zlika/theodore";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kaistarkk ];
  };
}
