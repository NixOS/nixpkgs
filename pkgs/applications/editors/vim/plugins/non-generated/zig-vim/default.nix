{
  lib,
  vimUtils,
  fetchFromCodeberg,
  nix-update-script,
}:
vimUtils.buildVimPlugin {
  pname = "zig.vim";
  version = "0-unstable-2026-02-13";

  src = fetchFromCodeberg {
    owner = "ziglang";
    repo = "zig.vim";
    rev = "f65b43b90cbc3e179b3146d2237f503783119ab8";
    hash = "sha256-4Ssde+vLYn/NnL24sDW6Z+yDN2dWKaOFgrFYm1oVQjg=";
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
