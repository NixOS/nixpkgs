{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  withProfile ? "accuracy",
}:
mkLibretroCore {
  core = "bsnes-mercury-${withProfile}";
  version = "0-unstable-2026-09-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bsnes-mercury";
    rev = "79d7f9de218b6ffa65a80bbdc5828532bc239232";
    hash = "sha256-MhhAE1K75FNLR4W8eIG7jmmImhU+JEMQVuAcgfzHUD8=";
  };

  makefile = "Makefile";
  makeFlags = [ "PROFILE=${withProfile}" ];

  meta = {
    description = "Fork of bsnes with HLE DSP emulation restored (${withProfile} profile)";
    homepage = "https://github.com/libretro/bsnes-mercury";
    license = lib.licenses.gpl3Only;
  };
}
