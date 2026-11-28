{
  lib,
  fetchFromGitHub,
  gitMinimal,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "jollycv";
  version = "0-unstable-2026-09-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "jollycv";
    rev = "2790d59c7194d29e83f8603ffd7e9da17f11575e";
    hash = "sha256-jPIlvy77zdTTeaEdFVdzKwGQIf9ipvZqK8u9r4QwFtQ=";
  };

  sourceRoot = "source/libretro";
  makefile = "Makefile";

  extraNativeBuildInputs = [ gitMinimal ];

  # The libretro Makefile writes object files outside sourceRoot.
  postPatch = ''
    chmod -R u+w ../deps ../src
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
