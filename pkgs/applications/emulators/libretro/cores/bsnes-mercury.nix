{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  withProfile ? "accuracy",
}:
mkLibretroCore {
  core = "bsnes-mercury-${withProfile}";
  version = "0-unstable-2026-07-26";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bsnes-mercury";
    rev = "d83bf7ab607e09131731b3a81825f986f91c1f84";
    hash = "sha256-VIjB3h8BKlq7Xx3xchgoKp1UxGuVXk7Ylix+hfiRR7A=";
  };

  makefile = "Makefile";
  makeFlags = [ "PROFILE=${withProfile}" ];

  meta = {
    description = "Fork of bsnes with HLE DSP emulation restored (${withProfile} profile)";
    homepage = "https://github.com/libretro/bsnes-mercury";
    license = lib.licenses.gpl3Only;
  };
}
