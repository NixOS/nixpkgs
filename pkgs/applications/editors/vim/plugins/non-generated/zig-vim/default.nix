{
  lib,
  vimUtils,
  fetchFromGitea,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "zig.vim";
  version = "0-unstable-2025-11-28";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ziglang";
    repo = "zig.vim";
    rev = "8ff80c24a2ff8fd9edd4a92c2f5793e921043cd6";
    hash = "sha256-VhEObsEYN/7o+U48MIywhPoYMHemXnKplX+zOrRHuxM=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Vim configuration for Zig";
    homepage = "https://codeberg.org/ziglang/zig.vim/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
