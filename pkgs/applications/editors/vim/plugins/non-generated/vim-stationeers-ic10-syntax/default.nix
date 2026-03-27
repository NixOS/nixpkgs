{
  lib,
  vimUtils,
  fetchFromGitLab,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "vim-ic10";
  version = "0-unstable-2025-11-02";

  src = fetchFromGitLab {
    owner = "LittleMorph";
    repo = "vim-ic10";
    rev = "74446a16078ef4f3d2088136b32af939fb6bc2a4";
    hash = "sha256-YCxrSB7eRQ54iZhpcsAR930Uccj+2ZyogpYGKbcSlys=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Stationeers IC10 syntax highlighting for Vim";
    homepage = "https://gitlab.com/LittleMorph/vim-ic10";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
