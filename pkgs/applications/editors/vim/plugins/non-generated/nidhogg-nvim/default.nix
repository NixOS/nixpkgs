{
  lib,
  vimUtils,
  fetchFromGitea,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "nidhogg.nvim";
  version = "0-unstable-2026-01-11";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "koibtw";
    repo = "nidhogg.nvim";
    rev = "a8c72aa204f68d5bd79a2508fbbed7b0ad2290cf";
    hash = "sha256-x8CryNcg3u5uCncCMTgK7yzCvk5MiomjKpdjNEoCQu4=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "DMC ranks for Neovim";
    homepage = "https://codeberg.org/koibtw/nidhogg.nvim";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
