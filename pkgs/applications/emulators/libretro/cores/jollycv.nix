{
  lib,
  fetchFromGitHub,
  gitMinimal,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "jollycv";
  version = "0-unstable-2026-04-02";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "jollycv";
    rev = "9ceb88e4370b2e04a597b03a9ffe4551c899d6c2";
    hash = "sha256-r0qqv6MipTJecCxxrSs0ptNT0hsWrdwuzdbyZQ5U1jU=";
  };

  sourceRoot = "source/libretro";
  makefile = "Makefile";

  extraNativeBuildInputs = [ gitMinimal ];

  postPatch = ''
    chmod -R u+w ..
  '';

  meta = {
    description = "ColecoVision, CreatiVision, and My Vision emulator core for libretro";
    homepage = "https://github.com/libretro/jollycv";
    license = with lib.licenses; [
      bsd3
      mit
    ];
    maintainers = with lib.maintainers; [ kaistarkk ];
  };
}
