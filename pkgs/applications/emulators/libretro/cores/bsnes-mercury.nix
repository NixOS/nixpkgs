{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  withProfile ? "accuracy",
}:
mkLibretroCore {
  core = "bsnes-mercury-${withProfile}";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bsnes-mercury";
    rev = "0f35d044bf2f2b879018a0500e676447e93a1db1";
    hash = "sha256-skVREKYITZn+gKKSZmwuBCWrG0jb/pifwIgat8VyQ8U=";
  };

  makefile = "Makefile";
  makeFlags = [ "PROFILE=${withProfile}" ];

  meta = {
    description = "Fork of bsnes with HLE DSP emulation restored (${withProfile} profile)";
    homepage = "https://github.com/libretro/bsnes-mercury";
    license = lib.licenses.gpl3Only;
  };
}
