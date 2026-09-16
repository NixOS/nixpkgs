{
  lib,
  fetchFromGitLab,
  mkLibretroCore,
  SDL2,
}:
mkLibretroCore {
  core = "emuscv";
  version = "0-unstable-2026-06-20";

  src = fetchFromGitLab {
    owner = "MaaaX-EPOCH84";
    repo = "libretro-emuscv";
    rev = "9c94f7c7fc9906133092ba1cf2adb8f4354236fb";
    hash = "sha256-dY5rePjFPWljyqvJox2yTEkV2nsT9IDcT4ViT0HF9dE=";
  };

  extraBuildInputs = [ SDL2 ];
  extraNativeBuildInputs = [ SDL2 ];
  buildFlags = [ "build-all" ];

  meta = {
    description = "Epoch/Yeno Super Cassette Vision emulator core for libretro";
    homepage = "https://gitlab.com/MaaaX-EPOCH84/libretro-emuscv";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kaistarkk ];
  };
}
