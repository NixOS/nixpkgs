{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  withProfile ? "accuracy",
}:
mkLibretroCore {
  core = "bsnes-mercury-${withProfile}";
  version = "0-unstable-2026-08-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bsnes-mercury";
    rev = "ea22363fb0c1ebe92e7a70cdf55e9bb43f9207be";
    hash = "sha256-3b0EKkoq5NWbHQbltb6RvMJ7cfdPSTm1GcLPjl139hs=";
  };

  makefile = "Makefile";
  makeFlags = [ "PROFILE=${withProfile}" ];

  meta = {
    description = "Fork of bsnes with HLE DSP emulation restored (${withProfile} profile)";
    homepage = "https://github.com/libretro/bsnes-mercury";
    license = lib.licenses.gpl3Only;
  };
}
