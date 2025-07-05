{
  lib,
  vimUtils,
  fetchFromSourcehut,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "hare.vim";
  version = "0-unstable-2025-04-24";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare.vim";
    rev = "41b8b615f46a39d807a9a069039aac79c925c389";
    hash = "sha256-GPFoQI6tipcLzkvjaeufmMrNnQM46lPas9D1SwzjKF4=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hare programming in Vim";
    homepage = "https://git.sr.ht/~sircmpwn/hare.vim";
    license = lib.licenses.vim;
    platforms = lib.platforms.all;
  };
}
