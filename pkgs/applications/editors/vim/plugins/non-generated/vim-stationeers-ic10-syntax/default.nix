{
  lib,
  vimUtils,
  fetchFromGitLab,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "vim-ic10";
  version = "0-unstable-2025-10-09";

  src = fetchFromGitLab {
    owner = "LittleMorph";
    repo = "vim-ic10";
    rev = "7e9cb3bf91f692e26e899a6d513fcee7dd60bf72";
    hash = "sha256-7mQ8PEbqQS4E8Kg6nU+uTj9Nyke80FEcLpmV46B7GFA=";
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
