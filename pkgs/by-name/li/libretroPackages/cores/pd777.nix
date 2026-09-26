{
  lib,
  fetchFromGitHub,
  gitMinimal,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "pd777";
  version = "0-unstable-2026-09-11";

  src = fetchFromGitHub {
    owner = "mittonk";
    repo = "PD777";
    rev = "331af5f53cc0ffbab90f915681c8dfe3a4cda0a2";
    hash = "sha256-ceRYCWPmReGCrFy09Akm1PT642pA5CQSaQcvLGDIJxI=";
  };

  sourceRoot = "source/source/libretro";

  extraNativeBuildInputs = [ gitMinimal ];

  postPatch = ''
    # The libretro Makefile writes object files outside sourceRoot.
    chmod -R u+w ../core
  '';

  meta = {
    description = "Epoch Cassette Vision emulator core for libretro";
    homepage = "https://github.com/mittonk/PD777";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaistarkk ];
  };
}
