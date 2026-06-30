{
  lib,
  fetchFromGitHub,
  gitMinimal,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "pd777";
  version = "0-unstable-2026-06-19";

  src = fetchFromGitHub {
    owner = "mittonk";
    repo = "PD777";
    rev = "118c8f893073f2e59eba6eb9fd1dd34d36318605";
    hash = "sha256-j52fWDJ5V0+9IsFT2lhdrkNWe/oaUrGUsLiki84CRXM=";
  };

  sourceRoot = "source/source/libretro";

  extraNativeBuildInputs = [ gitMinimal ];

  postPatch = ''
    chmod -R u+w ..
  '';

  meta = {
    description = "Epoch Cassette Vision emulator core for libretro";
    homepage = "https://github.com/mittonk/PD777";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaistarkk ];
  };
}
