{
  lib,
  vimUtils,
  fetchFromSourcehut,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "hare.vim";
  version = "unstable-2025-01-23";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare.vim";
    rev = "1a732aca2931402f3186f52ae626540a770aefe2";
    hash = "sha256-wBeQvDm7ZTUcw21VIAryyH6tMuBiQCMOJRZX/8ic8B4=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hare programming in Vim";
    homepage = "https://git.sr.ht/~sircmpwn/hare.vim";
    license = lib.licenses.vim;
    platforms = lib.platforms.all;
  };
}
