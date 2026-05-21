{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "quicknes";
  version = "0-unstable-2026-05-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "QuickNES_Core";
    rev = "a0ec494c417f365c578f3dacadb04383e4a99ade";
    hash = "sha256-q1AS4mASF2gaiGyuM6a/Z57bp0DPRQADlM+snb3iNSg=";
  };

  makefile = "Makefile";

  meta = {
    description = "QuickNES libretro port";
    homepage = "https://github.com/libretro/QuickNES_Core";
    license = lib.licenses.lgpl21Plus;
  };
}
