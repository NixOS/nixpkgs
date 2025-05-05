{
  lib,
  vimUtils,
  fetchFromGitLab,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "vim-ic10";
  version = "0-unstable-2025-01-08";

  src = fetchFromGitLab {
    owner = "LittleMorph";
    repo = "vim-ic10";
    rev = "7c1f13b198cfe122fb52f6abfb8dc95d5ca51013";
    hash = "sha256-4Q1JiDA7PBUWNBNfCIZC6nImhe2FJzOqrslHazAOs18=";
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
